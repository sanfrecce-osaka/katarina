require 'spec_helper'

RSpec.describe Katarina::Parser do
  describe '.parse' do
    let!(:path) { openapi_doc_path('openapi.yaml') }

    it 'returns 3 schema objects' do
      expect(Katarina::Parser.parse(path).length).to eq 3
      expect(Katarina::Parser.parse(path)).to all(be_a Katarina::Schema)
    end

    describe 'generated Schema object' do
      it 'has API' do
        expect(Katarina::Parser.parse(path).first.instance_variable_get(:@action)).to eq 'index'
      end

      it 'has an API path' do
        expect(Katarina::Parser.parse(path).first.instance_variable_get(:@path)).to eq :'/v1/users'
      end

      it 'has a controller name without suffix' do
        expect(Katarina::Parser.parse(path).first.instance_variable_get(:@controller)).to eq 'api/v1/users'
      end

      it 'has a response code' do
        expect(Katarina::Parser.parse(path).first.instance_variable_get(:@response_code)).to eq :'200'
      end

      it 'has an API response schema' do
        expect(Katarina::Parser.parse(path).first.instance_variable_get(:@schema)).to eq(
          {
            type: 'object',
            properties: {
              data: {
                type: 'array',
                items: {
                  type: 'object',
                  properties: {
                    id: { type: 'integer' },
                    name: { type: 'string' },
                    retired: { type: 'boolean' }
                  }
                }
              },
              total_pages: { type: 'integer' },
              current_page: { type: 'integer' },
              per_page: { type: 'integer' },
            }
          }
        )
      end
    end
  end
end
