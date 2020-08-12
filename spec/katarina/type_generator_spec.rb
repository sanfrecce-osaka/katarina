require 'spec_helper'

RSpec.describe Katarina::TypeGenerator do
  describe '.generate' do
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
        let!(:response_schema) do
          { type: 'string' }
        end

        it 'returns type what is string' do
          expect(Katarina::TypeGenerator.generate(schema_object)).to eq <<~TYPE
            type TApiV1UsersShow200 = string
          TYPE
        end
      end

      context 'when type is float' do
        let(:response_schema) do
          { type: 'float' }
        end

        it 'returns type what is number' do
          expect(Katarina::TypeGenerator.generate(schema_object)).to eq <<~TYPE
            type TApiV1UsersShow200 = number
          TYPE
        end
      end

      context 'when type is integer' do
        let(:response_schema) do
          { type: 'integer' }
        end

        it 'returns type what is number' do
          expect(Katarina::TypeGenerator.generate(schema_object)).to eq <<~TYPE
            type TApiV1UsersShow200 = number
          TYPE
        end
      end

      context 'when type is boolean' do
        let(:response_schema) do
          { type: 'boolean' }
        end

        it 'returns type what is boolean' do
          expect(Katarina::TypeGenerator.generate(schema_object)).to eq <<~TYPE
            type TApiV1UsersShow200 = boolean
          TYPE
        end
      end

      context 'when type is null' do
        let(:response_schema) do
          { type: 'null' }
        end

        it 'returns type what is null' do
          expect(Katarina::TypeGenerator.generate(schema_object)).to eq <<~TYPE
            type TApiV1UsersShow200 = null
          TYPE
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

          it 'returns type what is object whose value is string' do
            expect(Katarina::TypeGenerator.generate(schema_object)).to eq <<~TYPE
              type TApiV1UsersShow200 = {
                name: string
              }
            TYPE
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

          it 'returns type what is object whose value is number' do
            expect(Katarina::TypeGenerator.generate(schema_object)).to eq <<~TYPE
              type TApiV1UsersShow200 = {
                tax: number
              }
            TYPE
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

          it 'returns type what is object whose value is number' do
            expect(Katarina::TypeGenerator.generate(schema_object)).to eq <<~TYPE
              type TApiV1UsersShow200 = {
                id: number
              }
            TYPE
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

          it 'returns type what is object whose value is boolean' do
            expect(Katarina::TypeGenerator.generate(schema_object)).to eq <<~TYPE
              type TApiV1UsersShow200 = {
                retired: boolean
              }
            TYPE
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

          it 'returns type what is object whose value is null' do
            expect(Katarina::TypeGenerator.generate(schema_object)).to eq <<~TYPE
              type TApiV1UsersShow200 = {
                hobby: null
              }
            TYPE
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

          it 'returns type what is array whose item is string' do
            expect(Katarina::TypeGenerator.generate(schema_object)).to eq <<~TYPE
              type TApiV1UsersShow200 = string[]
            TYPE
          end
        end

        context 'when item is float' do
          let(:response_schema) do
            {
              type: 'array',
              items: { type: 'float' },
            }
          end

          it 'returns type what is array whose item is number' do
            expect(Katarina::TypeGenerator.generate(schema_object)).to eq <<~TYPE
              type TApiV1UsersShow200 = number[]
            TYPE
          end
        end

        context 'when item is integer' do
          let(:response_schema) do
            {
              type: 'array',
              items: { type: 'integer' },
            }
          end

          it 'returns type what is array whose item is number' do
            expect(Katarina::TypeGenerator.generate(schema_object)).to eq <<~TYPE
              type TApiV1UsersShow200 = number[]
            TYPE
          end
        end

        context 'when item is boolean' do
          let(:response_schema) do
            {
              type: 'array',
              items: { type: 'boolean' },
            }
          end

          it 'returns type what is array whose item is boolean' do
            expect(Katarina::TypeGenerator.generate(schema_object)).to eq <<~TYPE
              type TApiV1UsersShow200 = boolean[]
            TYPE
          end
        end

        context 'when item is null' do
          let(:response_schema) do
            {
              type: 'array',
              items: { type: 'null' },
            }
          end

          it 'returns type what is array whose item is null' do
            expect(Katarina::TypeGenerator.generate(schema_object)).to eq <<~TYPE
              type TApiV1UsersShow200 = null[]
            TYPE
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

        xit 'returns type what is object<object<array>>' do
          expect(Katarina::TypeGenerator.generate(schema_object)).to eq <<~TYPE
            type TApiV1UsersShow200 = {
              level1: {
                level2: string[]
              }
            }
          TYPE
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

        it 'returns type what is object<object[]>' do
          expect(Katarina::TypeGenerator.generate(schema_object)).to eq <<~TYPE
            type TApiV1UsersShow200 = {
              level1: {
                level3: number
              }[]
            }
          TYPE
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

        it 'returns type what is object<object<object>>' do
          expect(Katarina::TypeGenerator.generate(schema_object)).to eq <<~TYPE
            type TApiV1UsersShow200 = {
              level1: {
                level2: {
                  level3: number
                }
              }
            }
          TYPE
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

        xit 'returns type what is object[][]' do
          expect(Katarina::TypeGenerator.generate(schema_object)).to eq <<~TYPE
            type TApiV1UsersShow200 = {
              level3: boolean
            }[][]
          TYPE
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

        xit 'returns type what is object<array>[]' do
          expect(Katarina::TypeGenerator.generate(schema_object)).to eq <<~TYPE
            type TApiV1UsersShow200 = {
              level2: null[]
            }[]
          TYPE
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

        it 'returns type what is array[][]' do
          expect(Katarina::TypeGenerator.generate(schema_object)).to eq <<~TYPE
            type TApiV1UsersShow200 = string[][][]
          TYPE
        end
      end
    end
  end
end
