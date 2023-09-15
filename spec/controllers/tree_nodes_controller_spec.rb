require 'rails_helper'
require 'json'

def construct_tree(root_id, child_id1, child_id2)
  [
    {
      "#{root_id}"=>
        {
          "label"=>"root",
          "children"=>[
            {
              "#{child_id1}"=>
                {
                  "label"=>"cat",
                  "children"=>[]
                }
            },
            {
              "#{child_id2}"=>
                {
                  "label"=>"dog",
                  "children"=>[]
                }
            }
          ]
        }
    }
  ]
end

#We follow AAA-Arrange, Act, Assert for all the test cases
RSpec.describe Api::TreeNodesController, type: :request do

  describe 'WITH_VALID_CASES: when tree is empty' do
    let(:url) {"/api/tree"}
    let(:valid_params) do
      {
        parent: nil,
        label: 'root'
      }
    end
    let(:headers) do
      {
        CONTENT_TYPE: 'application/json',
        ACCEPT: 'application/json'
      }
    end
    context '#INDEX - GET' do
      it 'should return empty array with status code 200' do
        get url
        res_body = JSON.parse(response.body)
        expect(response.status).to eq 200
        expect(res_body).to eq([])
      end
    end

    context '#CREATE -POST' do
      context 'when tree is empty' do
        context 'make first time post with valid params' do
          it 'should return array with status code 201', :focus do
            post url, params: valid_params.to_json, headers: headers
            res_data = JSON.parse(response.body)
            expect(response.status).to eq 201
            expect(res_data["message"]).to match(/added as root!!/)
          end
        end
      end
    end

    context 'when tree is not empty' do
      context 'make post with valid params (parent and label)' do
        it 'should return with expected format' do
          get url
          res_data_after_first_level_insert = JSON.parse(response.body)
          parent_id = res_data_after_first_level_insert[0].keys[0]
          child = { parent: parent_id }

          post url, params: child.merge({label: 'cat'}).to_json,  headers: headers
          post url, params: child.merge({label: 'dog'}).to_json, headers: headers

          tree = TreeNode.tree
          keys = tree[0][parent_id][:children].map{|hash| hash.keys[0]}
          child_id1 = keys[0]
          child_id2 = keys[1]
          formatted_data = construct_tree(parent_id, child_id1, child_id2)

          get url
          res_data_after_sec_level_insert  = JSON.parse(response.body)

          expect(res_data_after_sec_level_insert).to eq(formatted_data)
        end
      end
    end

    context '#CREATE -POST' do
      context 'when tree is not empty' do
        context 'add one more root node' do
          it 'should return array with status code 201' do
            valid_params_for_index_1 = { root_index: 1}
            post url, params: valid_params.merge(valid_params_for_index_1).to_json, headers: headers
            res_data = JSON.parse(response.body)
            expect(response.status).to eq 201
            expect(res_data["message"]).to match(/added as root!!/)
          end
        end
      end
    end
  end

  describe 'WITH_INVALID_CASES: when tree is empty' do
    let(:url) {"/api/tree"}
    let(:invalid_params_with_non_existent_parent) do
      {
        parent: "fsadfsadfsad",
        label: 'rat'
      }
    end
    let(:invalid_params_with_int_parent_id) do
      {
        parent: 345123412,
        label: 'rat'
      }
    end
    let(:invalid_params_invalid_root_index) do
      {
        parent: "345123412",
        label: 'rat',
        root_index: 7
      }
    end
    let(:invalid_params_parent_not_passed) do
      {
        label: 'rat',
        root_index: 7
      }
    end
    let(:invalid_params_label_not_passed) do
      {
        parent: "345123412",
        root_index: 7
      }
    end
    let(:headers) do
      {
        CONTENT_TYPE: 'application/json',
        ACCEPT: 'application/json'
      }
    end
    context 'Parent id not present' do
      it 'should return parent not found message with 404 status' do
        post url, params: invalid_params_with_non_existent_parent.to_json, headers: headers
        res_data = JSON.parse(response.body)
        expect(response.status).to eq 404
        expect(res_data["message"]).to match(/Parent id - 'fsadfsadfsad' not found/)
      end
    end

    context 'Parent id not present' do
      it 'should return parent not found message with 404 status' do
        post url, params: invalid_params_with_int_parent_id.to_json, headers: headers
        res_data = JSON.parse(response.body)
        expect(response.status).to eq 400
        expect(res_data["message"]).to match(/The parent should be null or string type/)
      end
    end

    context 'Root index greater than tree length' do
      it 'should raise Root index not found' do
        post url, params: invalid_params_invalid_root_index.to_json, headers: headers
        res_data = JSON.parse(response.body)
        expect(response.status).to eq 404
        expect(res_data["message"]).to match(/Root index not found/)
      end
    end

    context 'when parent is not passed' do
      it 'should rails Invalid param missing error' do
        post url, params: invalid_params_parent_not_passed.to_json, headers: headers
        res_data = JSON.parse(response.body)
        expect(response.status).to eq 400
        expect(res_data["message"]).to match(/Invalid param missing error/)
      end
    end

    context 'when label is not passed' do
      it 'should raise Invalid param missing error' do
        post url, params: invalid_params_label_not_passed.to_json, headers: headers
        res_data = JSON.parse(response.body)
        expect(response.status).to eq 400
        expect(res_data["message"]).to match(/Invalid param missing error/)
      end
    end
  end
end
