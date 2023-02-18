require 'nokogiri'
require 'open-uri'
require 'fileutils'

if ARGV.size < 2
    puts "Usage: ruby #{__FILE__} LIBRARY MEDIA M3U" 
    puts ""
    puts "Where:"
    puts "LIBRARY: The name of the XML file, eg library.xml"
    puts "MEDIA: The name of the directory containing the actual music files. Must be on the same file level of this script."
    puts "M3U: Optional, the name of the directory where the m3u files will be stored. Default is 'M3U'"
    exit
end

LIBRARY_NAME = ARGV[0].to_s
MEDIA_NAME = ARGV[1].to_s
M3U_NAME = ARGV[2].to_s.empty? ? "M3U" : ARGV[2].to_s

#LIBRARY_PATH = ARGV[0].to_s
#ORIGINAL_MEDIA_PATH = "/Users/djtaxxodium/Desktop/DJTaxxTraxx/"
#CURRENT_MEDIA_PATH = ARGV[1].to_s
#SAVE_PATH = ARGV[2].to_s

if !(Dir.exists?(LIBRARY_NAME) && Dir.exists?(MEDIA_NAME))
    puts "Library file and/or media directory could not be found."
    puts "Please check the name and try again."
    exit
end

@media_list = collect_tracks

def collect_tracks
    doc = Nokogiri::XML(URI::open(LIBRARY_PATH))

    collection = doc.xpath('//DJ_PLAYLISTS/COLLECTION/TRACK')

    list = []

    collection.each do |track|
        media = Hash.new
        media["id"] = track["TrackID"]
        media["url"] = track["Location"]
        media["artist"] = track["Artist"]
        media["song"] = track["Name"]
        list << media
    end

    list
end

def process(nodes, path)
    nodes.each do |node|
        next unless node.name == "NODE"

        case node["Type"]
        when "0"
            new_path = "#{path}/#{node["Name"].gsub("/", "-")}" unless node["Name"] == "ROOT"
            
            Dir::mkdir(new_path) unless Dir.exists?(new_path)

            process(node.children, new_path)
        when "1"
            name = node["Name"].gsub("/", "-")
            tracks = get_tracks(node)
    
            next if tracks.empty?
    
            m3u = generate_m3u(tracks)
    
            f = File.new("#{path}/#{name}.m3u", "w")
            f.write(m3u)
            f.close
        end
    end
end

def get_tracks(node)
    tracks = []

    return tracks unless node.name == "NODE" && node["Type"] == "1"

    node.children.each do |track|
        media = @media_list.find { |media| media["id"] == track["Key"] }
        tracks << media unless media.nil?
    end

    tracks
end

def generate_m3u(tracks)
    m3u = ""
    m3u << "#EXTM3U\n"

    tracks.each do |track|
        artist = track["artist"].to_s
        song = track["song"].to_s
        url = URI.decode(track["url"])

        match = url.match /(.*)#{MEDIA_NAME}/

        puts match[0]
        exit

        ##url = url.to_s.gsub("#{ORIGINAL_MEDIA_PATH}", "#{CURRENT_MEDIA_PATH+"/"}")
        #url = url.to_s.gsub("#{ORIGINAL_MEDIA_PATH}", "/DJTaxxTraxx/")
        #url = url.gsub("file://localhost", "")

        m3u << "#EXTINF:#{track["id"]},#{artist} - #{song}\n"
        m3u << "#{url}\n"
    end

    m3u
end

FileUtils.rm_rf(M3U_NAME) if Dir.exists?(M3U_NAME) and M3U_NAME != "/"
Dir::mkdir(M3U_NAME)

root_playlist = doc.xpath('//DJ_PLAYLISTS/PLAYLISTS/NODE[@Type=0]')[0]
process(root_playlist.children, M3U_NAME)

