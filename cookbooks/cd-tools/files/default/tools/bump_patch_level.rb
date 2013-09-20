#!/opt/chef/embedded/bin/ruby

def bump_patch_level(metadatarb)
  File.open(metadatarb, 'r+') do |f|
    lines = f.readlines
    lines.each do |line|
      if line =~ /^version\s+["'](\d+)\.(\d+)\.(\d+)["'].*$/
        major = $1
        minor = $2
        patch = $3
        new_patch = patch.to_i + 1
        puts "Incrementing #{metadatarb} version from #{major}.#{minor}.#{patch} to #{major}.#{minor}.#{new_patch}"
        line.replace("version          \"#{major}.#{minor}.#{new_patch}\"\n")
      end
    end
    f.pos = 0
    lines.each do |line|
      f.print line
    end
    f.truncate(f.pos)
  end
end

updated = false

if !system("git checkout pre-master")
  raise "Failed to checkout pre-master"
end

if !system("git pull")
  raise "Failed to git pull pre-master"
end

if File.exists?('metadata.rb')
  metadata_file = File.expand_path("metadata.rb")
  bump_patch_level(metadata_file)
  if !system("git add #{metadata_file}")
    raise "Failed to git add #{metdata_file}: #{$?}"
  end
  updated = true
end

if updated
  if !system("git commit -m 'Updated patch level for cookbook'")
    raise "Failed to git commit"
  end

  if !system("git push origin pre-master")
    raise "Failed to git push"
  end
end
