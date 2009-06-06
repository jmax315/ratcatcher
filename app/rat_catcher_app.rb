require 'app/rat_catcher_store.rb'


class RatCatcherApp

  attr_accessor :data_file_name,
                :store

  def initialize
    @store= nil
  end

  def replace_node(path, new_text)
    @store= @store.replace_node(path, new_text)
  end

  def load(file_name)
    sourcefile = File.new(file_name)
    sourcecode = sourcefile.gets(nil)
    sourcefile.close
    sourcecode
  end

  def args(argv)
    @data_file_name= argv[0]
    @store= RatCatcherStore.parse(load(@data_file_name))
    tree_view.model= RatCatcherStoreGtkWrapper.new(@store)
    tree_view.show
  end

  def run
  end

  def save
    File.open(@data_file_name, 'w') do | f |
      f.write(store.to_s)
    end
  end

end
