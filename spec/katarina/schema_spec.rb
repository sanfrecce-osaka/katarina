require 'spec_helper'

RSpec.describe Katarina::Schema do
  describe '#types' do
    let!(:schema_object) do
      Katarina::Schema.new(
        :'/v1/users/{id}',
        'api/v1/users',
        'show',
        'get',
        :'200',
        response_schema,
      )
    end

    context 'when schema is not nested' do
      context 'when type is string' do
        let(:response_schema) do
          { type: 'string' }
        end

        it "returns 'string'" do
          expect(schema_object.types).to eq 'string'
        end
      end

      context 'when type is float' do
        let(:response_schema) do
          { type: 'float' }
        end

        it "returns 'float'" do
          expect(schema_object.types).to eq 'float'
        end
      end

      context 'when type is integer' do
        let(:response_schema) do
          { type: 'integer' }
        end

        it "returns 'integer'" do
          expect(schema_object.types).to eq 'integer'
        end
      end

      context 'when type is boolean' do
        let(:response_schema) do
          { type: 'boolean' }
        end

        it "returns 'boolean'" do
          expect(schema_object.types).to eq 'boolean'
        end
      end

      context 'when type is null' do
        let(:response_schema) do
          { type: 'null' }
        end

        it "returns 'null'" do
          expect(schema_object.types).to eq 'null'
        end
      end

      context 'when type is object' do
        context 'when property is string' do
          let(:response_schema) do
            {
              type: 'object',
              properties: {
                name: { type: 'string' },
              }
            }
          end

          it "returns hash whose value is 'string'" do
            expect(schema_object.types).to eq({ name: 'string' })
          end
        end

        context 'when property is float' do
          let(:response_schema) do
            {
              type: 'object',
              properties: {
                tax: { type: 'float' },
              }
            }
          end

          it "returns hash whose value is 'float'" do
            expect(schema_object.types).to eq({ tax: 'float' })
          end
        end

        context 'when property is integer' do
          let(:response_schema) do
            {
              type: 'object',
              properties: {
                id: { type: 'integer' },
              }
            }
          end

          it "returns hash whose value is 'integer'" do
            expect(schema_object.types).to eq({ id: 'integer' })
          end
        end

        context 'when property is boolean' do
          let(:response_schema) do
            {
              type: 'object',
              properties: {
                retired: { type: 'boolean' },
              }
            }
          end

          it "returns hash whose value is 'boolean'" do
            expect(schema_object.types).to eq({ retired: 'boolean' })
          end
        end

        context 'when property is null' do
          let(:response_schema) do
            {
              type: 'object',
              properties: {
                hobby: { type: 'null' },
              }
            }
          end

          it "returns hash whose value is 'null'" do
            expect(schema_object.types).to eq({ hobby: 'null' })
          end
        end
      end

      context 'when type is array' do
        context 'when item is string' do
          let(:response_schema) do
            {
              type: 'array',
              items: { type: 'string' },
            }
          end

          it "returns array whose item is 'string'" do
            expect(schema_object.types).to eq ['string']
          end
        end

        context 'when item is float' do
          let(:response_schema) do
            {
              type: 'array',
              items: { type: 'float' },
            }
          end

          it "returns array whose item is 'float'" do
            expect(schema_object.types).to eq ['float']
          end
        end

        context 'when item is integer' do
          let(:response_schema) do
            {
              type: 'array',
              items: { type: 'integer' },
            }
          end

          it "returns array whose item is 'integer'" do
            expect(schema_object.types).to eq ['integer']
          end
        end

        context 'when item is boolean' do
          let(:response_schema) do
            {
              type: 'array',
              items: { type: 'boolean' },
            }
          end

          it "returns array whose item is 'boolean'" do
            expect(schema_object.types).to eq ['boolean']
          end
        end

        context 'when item is null' do
          let(:response_schema) do
            {
              type: 'array',
              items: { type: 'null' },
            }
          end

          it "returns array whose item is 'null'" do
            expect(schema_object.types).to eq ['null']
          end
        end
      end
    end

    context 'when schema is nested' do
      context 'when object > object > array' do
        let(:response_schema) do
          {
            type: 'object',
            properties: {
              level1: {
                type: 'object',
                properties: {
                  level2: {
                    type: 'array',
                    items: { type: 'string' },
                  },
                },
              },
            },
          }
        end

        it 'returns hash > hash > array' do
          expect(schema_object.types).to eq(
            {
              level1: { level2: ['string'] },
            }
          )
        end
      end

      context 'when object > array > object' do
        let(:response_schema) do
          {
            type: 'object',
            properties: {
              level1: {
                type: 'array',
                items: {
                  type: 'object',
                  properties: {
                    level3: { type: 'float' }
                  },
                },
              },
            },
          }
        end

        it 'returns hash > array > hash' do
          expect(schema_object.types).to eq(
            {
              level1: [{ level3: 'float' }] ,
            }
          )
        end
      end

      context 'when object > object > object' do
        let(:response_schema) do
          {
            type: 'object',
            properties: {
              level1: {
                type: 'object',
                properties: {
                  level2: {
                    type: 'object',
                    properties: {
                      level3: { type: 'integer' }
                    },
                  },
                },
              },
            },
          }
        end

        it 'returns hash > hash > hash' do
          expect(schema_object.types).to eq(
            {
              level1: {
                level2: {
                  level3: 'integer'
                },
              },
            }
          )
        end
      end

      context 'when array > array > object' do
        let(:response_schema) do
          {
            type: 'array',
            items: {
              type: 'array',
              items: {
                type: 'object',
                properties: {
                  level3: { type: 'boolean' }
                },
              },
            },
          }
        end

        it 'returns array > array > hash' do
          expect(schema_object.types).to eq(
            [
              [{ level3: 'boolean' }]
            ]
          )
        end
      end

      context 'when array > object > array' do
        let(:response_schema) do
          {
            type: 'array',
            items: {
              type: 'object',
              properties: {
                level2: {
                  type: 'array',
                  items: { type: 'null' },
                },
              },
            },
          }
        end

        it 'returns array > hash > array' do
          expect(schema_object.types).to eq(
            [
              { level2: ['null'] }
            ]
          )
        end
      end

      context 'when array > array > array' do
        let(:response_schema) do
          {
            type: 'array',
            items: {
              type: 'array',
              items: {
                type: 'array',
                items: { type: 'string' },
              },
            },
          }
        end

        it 'returns array > array > array' do
          expect(schema_object.types).to eq(
            [
              [
                ['string']
              ]
            ]
          )
        end

      end
    end
  end

  describe '#name' do
    let!(:config) do
      Katarina.configure do |config|
        config.exclude_paths = exclude_paths
        config.prefix = prefix
      end
    end

    let!(:schema_object) do
      Katarina::Schema.new(
        :'/v1/users/{id}',
        'api/v1/users',
        'show',
        'get',
        :'200',
        { type: 'string' }
      )
    end

    after do
      Katarina.configure do |config|
        config.exclude_paths = []
        config.prefix = true
      end
    end

    context 'when config is default' do
      let(:exclude_paths) { [] }
      let(:prefix) { true }

      it 'returns default type name' do
        expect(schema_object.name).to eq 'TApiV1UsersShow200'
      end
    end

    context 'when exclude_paths are api and v1' do
      let(:exclude_paths) { %w[api v1] }
      let(:prefix) { true }

      it 'returns type name except for the specified path' do
        expect(schema_object.name).to eq 'TUsersShow200'
      end
    end

    context 'when prefix is false' do
      let(:exclude_paths) { [] }
      let(:prefix) { false }

      it 'returns type name without prefix' do
        expect(schema_object.name).to eq 'ApiV1UsersShow200'
      end
    end
  end
end
