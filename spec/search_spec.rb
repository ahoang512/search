require_relative '../search'

describe '#display_fields' do
  let(:hash) do
    {
      '_id' => 1,
      'name' => 'John'
    }
  end

  let(:expected_output) do
    [
      "Search Fields",
      "Index: Field",
      "0      _id",
      "1      name",
      "**********************\n"
    ].join("\n")
  end

  it 'prints out the fields and their indexes' do
    expect { display_fields([hash]) }.to output(expected_output).to_stdout
  end
end

describe '#search_for_hash' do
  let(:hash_1) do
    {
      '_id' => 1,
      'name' => 'John'
    }
  end

  let(:hash_2) do
    {
      '_id' => 2,
      'name' => 'Jill'
    }
  end

  let(:hashes) { [hash_1, hash_2] }

  it 'returns the matching hash based on key and value' do
    expect(search_for_hash(hashes, '_id', '1')).to eq([hash_1])
  end
end

describe '#organization_name' do
  it 'returns the orgnization name corresponding to the id' do
    expect(organization_name('101')).to eq('Enthaze')
  end

  it 'returns nil if organization_id is not there' do
    expect(organization_name('')).to eq(nil)
  end
end
