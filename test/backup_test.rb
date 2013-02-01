require 'minitest/spec'
require 'minitest/autorun'

require_relative '../lib/backup'

describe 'repo paths' do

  it 'should extract only the repo name from git path' do
    repo = 'https://github.com/boxuk/box_uk_library_app.git'
    result = split_repo_name(repo)
    result.must_equal 'box_uk_library_app'
  end

  it 'should find the correct path even if a dot is present' do
    repo = 'https://github.com/boxuk/wedge.js.git'
    result = split_repo_name(repo)
    result.must_equal 'wedge.js'
  end
end

describe 'repo urls' do

  it 'should retunr the correct url' do
    result = repo_url('bob', 'secret', 'boxuk', 'micro')
    expected = 'https://bob:secret@github.com/boxuk/micro.git'
    result.must_equal expected
  end
end
