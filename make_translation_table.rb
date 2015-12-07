require 'yaml'
require 'pp'

table = YAML.load(File.read('Project明治回帰.yaml')).sort_by {|x| x['en'].downcase }
puts File.read('src/translation-table-template.md')
puts '| 英 | 和 | 参考訳 | ＊ |'
puts '|----|----|--------|----|'
table.each do |x|
  next unless x['en'] && x['ja']
  #next if x['common']
  puts ['', x['en'], x['ja'], x['common'], x['yamato']].join('|')
end
