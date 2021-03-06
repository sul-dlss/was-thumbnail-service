# frozen_string_literal: true

describe Was::ThumbnailService::Synchronization::TimemapDatabaseParser do
  VCR.configure do |config|
    config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
    config.hook_into :webmock # or :fakeweb
  end

  describe '.initialize' do
    it 'initializes the TimemapDatabaseParser with uri' do
      timemap_parser = TimemapDatabaseParser.new('http://test1.edu/')
      expect(timemap_parser.instance_variable_get(:@uri)).to eq('http://test1.edu/')
    end
  end

  before :all do
    Memento.delete_all
    SeedUri.delete_all
    @uri1 = SeedUri.create(id: 1001, uri: 'http://test1.edu/', druid_id: 'aa111aa1111')
    @memento11 = Memento.create(id: 10_001, uri_id: 1001, memento_uri: 'https://swap.stanford.edu/19980901000000/http://test1.edu/', memento_datetime: '1998-09-01 00:00:00')
    @memento12 = Memento.create(id: 10_002, uri_id: 1001, memento_uri: 'https://swap.stanford.edu/19990901000000/http://test1.edu/', memento_datetime: '1999-09-01 00:00:00')
    @memento13 = Memento.create(id: 10_003, uri_id: 1001, memento_uri: 'https://swap.stanford.edu/20000901000000/http://test1.edu/', memento_datetime: '2000-09-01 00:00:00')

    @uri2 = SeedUri.create(id: 1002, uri: 'http://test2.edu/', druid_id: 'bb111bb1111')

    @uri3 = SeedUri.create(id: 1003, uri: 'http://test3.edu/', druid_id: 'cc111cc1111')
    @memento31 = Memento.create(id: 10_004, uri_id: 1003, memento_uri: 'https://swap.stanford.edu/19980901000000/http://test1.edu/', memento_datetime: '1998-09-01 00:00:00')
    @memento32 = Memento.create(id: 10_005, uri_id: 1003, memento_uri: '', memento_datetime: '1999-09-01 00:00:00')
    @memento33 = Memento.create(id: 10_006, uri_id: 1003, memento_datetime: '1999-09-01 00:00:00')
    @memento34 = Memento.create(id: 10_007, uri_id: 1003, memento_uri: 'https://swap.stanford.edu/19990901000000/http://test1.edu/', memento_datetime: '')
    @memento35 = Memento.create(id: 10_008, uri_id: 1003, memento_uri: 'https://swap.stanford.edu/19990901000000/http://test1.edu/')
    @memento36 = Memento.create(id: 10_009, uri_id: 1003)
  end

  describe '.timemap' do
    it 'should return a memento hash for existent uri and available mementos' do
      timemap_parser = TimemapDatabaseParser.new('http://test1.edu/')
      mementos_hash = timemap_parser.timemap
      expect(mementos_hash.length).to eq(3)
      expect(mementos_hash['19980901000000']).to eq('https://swap.stanford.edu/19980901000000/http://test1.edu/')
    end

    it 'should return an empty hash for existent uri without mementos' do
      timemap_parser = TimemapDatabaseParser.new('http://test2.edu/')
      mementos_hash = timemap_parser.timemap
      expect(mementos_hash.length).to eq(0)
    end

    it 'should return avoid the not-complete records ' do
      timemap_parser = TimemapDatabaseParser.new('http://test3.edu/')
      mementos_hash = timemap_parser.timemap
      expect(mementos_hash.length).to eq(1)
    end

    it 'should return an empty hash for non-existent uri' do
      timemap_parser = TimemapDatabaseParser.new('http://test4.edu/')
      mementos_hash = timemap_parser.timemap
      expect(mementos_hash.length).to eq(0)
    end

    it 'should return an empty hash for empty uri' do
      timemap_parser = TimemapDatabaseParser.new('')
      mementos_hash = timemap_parser.timemap
      expect(mementos_hash.length).to eq(0)
    end

    it 'should return an empty hash for nil uri' do
      timemap_parser = TimemapDatabaseParser.new(nil)
      mementos_hash = timemap_parser.timemap
      expect(mementos_hash.length).to eq(0)
    end
  end

  after :all do
    @uri1.destroy
    @uri2.destroy
    @uri3.destroy
    @memento11.destroy
    @memento12.destroy
    @memento13.destroy
    @memento31.destroy
    @memento32.destroy
    @memento33.destroy
    @memento34.destroy
    @memento35.destroy
    @memento36.destroy
  end
end
