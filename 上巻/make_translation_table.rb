require 'yaml'
require 'pp'

class String
    def tr(width , suffix = "...")
        i = 0
        self.each_char.inject(0) do |c, x|
            c += x.ascii_only? ? 1 : 2
            i += 1
            next c if c <= width || i == self.length
            return self[0 , i - suffix.length] + suffix
        end
        return self
    end
end

table = YAML.load(File.read('Project明治回帰.yaml')).sort_by {|x| x['en'].downcase }
puts File.read('src/translation-table-template.md')
puts '| 英 | 和 | 参考訳 |'
puts '|----|----|--------|'
table.each do |x|
  next unless x['en'] && x['ja']
  #next if x['common']
  puts ['', x['en'].tr(31), x['ja'].tr(31), (x['common']||'').tr(31) ].join('|')
end
