require 'test/helper'

class Nanoc3::DataSourceTest < MiniTest::Unit::TestCase

  def setup    ; global_setup    ; end
  def teardown ; global_teardown ; end

  def test_loading
    # Create data source
    data_source = Nanoc3::DataSource.new(nil)
    data_source.expects(:up).times(1)
    data_source.expects(:down).times(1)

    # Test nested loading
    assert_equal(0, data_source.instance_eval { @references })
    data_source.loading do
      assert_equal(1, data_source.instance_eval { @references })
      data_source.loading do
        assert_equal(2, data_source.instance_eval { @references })
      end
      assert_equal(1, data_source.instance_eval { @references })
    end
    assert_equal(0, data_source.instance_eval { @references })
  end

  def test_not_implemented
    # Create data source
    data_source = Nanoc3::DataSource.new(nil)

    # Test optional methods
    data_source.up
    data_source.down
    data_source.update

    # Test required methods - general
    assert_raises(NotImplementedError) { data_source.setup }

    # Test required methods - loading data
    assert_raises(NotImplementedError) { data_source.pages }
    assert_raises(NotImplementedError) { data_source.assets }
    assert_raises(NotImplementedError) { data_source.layouts }
    assert_raises(NotImplementedError) { data_source.code }

    # Test required method - creating data
    assert_raises(NotImplementedError) { data_source.create_page(nil, nil, nil) }
    assert_raises(NotImplementedError) { data_source.create_layout(nil, nil, nil) }
  end

end
