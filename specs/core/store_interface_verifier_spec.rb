
describe "RatCatcherStore duck-typing:" do
  current_dir= File.expand_path(File.dirname(__FILE__))
  Dir.glob(current_dir + "/../../app/store_nodes/*.rb").each do |store_file|
    klass= RatCatcherStore.class_for_file_name(store_file)
    it "#{klass} should have a sexp method" do
      klass.should be_method_defined(:sexp)
    end
  end
end
