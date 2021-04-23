require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {{"CONTENT_TYPE" => "application/json",
                  "ACCEPT" => 'application/json'}}
  let(:question) { create(:question) }

  describe 'GET index' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}
      let(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before {get api_path, params: {access_token: access_token.token, question_id: question}, headers: headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(json['answers'].first[attr]).to eq answers.first.send(attr).as_json
        end
      end
    end
  end

  describe 'GET show' do
    let(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:access_token) {create(:access_token)}
    let!(:links) { create_list(:link, 3, linkable: answer) }
    let!(:comments) { create_list(:comment, 3, commentable: answer, user: create(:user)) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    before do
      2.times { answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb') }
      get api_path, params: {access_token: access_token.token, id: answer}, headers: headers
    end

    it 'returns 200 status' do
      expect(response).to be_successful
    end

    it 'contains user object' do
      expect(json['answer']['user']['id']).to eq answer.user.id
    end

    it 'contains question object' do
      expect(json['answer']['question']['title']).to eq answer.question.title
    end

    it 'returns list of links' do
      expect(json['answer']['links'].size).to eq links.size
      expect(json['answer']['links'].first['url']).to eq links.first.url
    end

    it 'returns list of comments' do
      expect(json['answer']['comments'].size).to eq 3
      expect(json['answer']['comments'].first['body']).to eq comments.first.body
    end

    it 'returns list of files' do
      expect(json['answer']['files'].size).to eq 2
      expect(json['answer']['files'].first['name']).to eq 'rails_helper.rb'
    end
  end

  describe 'PATCH update' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:answer) { create(:answer, user: user) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    it 'update answer' do
      patch api_path, params: {access_token: access_token.token, id: answer,  answer: {body: 'updated body'}}.to_json, headers: headers
      expect(json['answer']['body']).to eq 'updated body'
    end

    it 'invalid update answer' do
      patch api_path, params: {access_token: access_token.token, id: answer,  answer: {body: nil}}.to_json, headers: headers
      expect(response).to_not be_successful
    end
  end

  describe 'DELETE destroy' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:answer) { create(:answer, user: user) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    it 'deletes answer' do
      delete api_path, params: {access_token: access_token.token, id: answer}.to_json, headers: headers
      expect(json['deleted']).to eq 'successful'
    end
  end

  describe 'POST create' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/" }
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    it 'post answer' do
      post api_path, params: {access_token: access_token.token, question_id: question, answer: attributes_for(:answer)}.to_json, headers: headers
      expect(json['answer']).to_not eq nil
    end

    it 'post invalid answer' do
      post api_path, params: {access_token: access_token.token, question_id: question, answer: attributes_for(:answer, :invalid)}.to_json, headers: headers
      expect(json.first).to eq "Body can't be blank"
    end
  end
end
