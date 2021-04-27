require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {{"CONTENT_TYPE" => "application/json",
                  "ACCEPT" => 'application/json'}}

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before {get api_path, params: {access_token: access_token.token}, headers: headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET show' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:access_token) {create(:access_token)}
    let!(:answers) { create_list(:answer, 3, question: question) }
    let!(:links) { create_list(:link, 3, linkable: question) }
    let!(:comments) { create_list(:comment, 3, commentable: question, user: create(:user)) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    before do
      2.times { question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb') }
      get api_path, params: {access_token: access_token.token, id: question}, headers: headers
    end

    it 'returns 200 status' do
      expect(response).to be_successful
    end

    it 'returns all public fields' do
      %w[id title body created_at updated_at].each do |attr|
        expect(json['question'][attr]).to eq question.send(attr).as_json
      end
    end

    it 'contains user object' do
      expect(json['question']['user']['id']).to eq question.user.id
    end

    it 'returns list of links' do
      expect(json['question']['links'].size).to eq links.size
      expect(json['question']['links'].first['url']).to eq links.first.url
    end

    it 'returns list of comments' do
      expect(json['question']['comments'].size).to eq 3
      expect(json['question']['comments'].first['body']).to eq comments.first.body
    end

    it 'returns list of files' do
      expect(json['question']['files'].size).to eq 2
      expect(json['question']['files'].first['name']).to eq 'rails_helper.rb'
    end

    it 'returns list of answers' do
      expect(json['question']['answers'].size).to eq 3
    end
  end

  describe 'PATCH update' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:question) { create(:question, user: user) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    it 'update question' do
      patch api_path, params: {access_token: access_token.token, id: question,  question: {title: 'updated title', body: 'updated body'}}.to_json, headers: headers
      expect(json['question']['title']).to eq 'updated title'
      expect(json['question']['body']).to eq 'updated body'
    end

    it 'invalid update question' do
      patch api_path, params: {access_token: access_token.token, id: question,  question: {title: nil}}.to_json, headers: headers
      expect(response).to_not be_successful
    end

    describe 'DELETE destroy' do
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:question) { create(:question, user: user) }

      it_behaves_like 'API Authorizable' do
        let(:method) { :delete }
      end

      it 'deletes question' do
        delete api_path, params: {access_token: access_token.token, id: question}.to_json, headers: headers
        expect(json['deleted']).to eq 'successful'
      end
    end

    describe 'POST create' do
      let(:api_path) { "/api/v1/questions/" }
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }

      it_behaves_like 'API Authorizable' do
        let(:method) { :post }
      end

      it 'post question' do
        post api_path, params: {access_token: access_token.token, question: attributes_for(:question)}.to_json, headers: headers
        expect(json['question']).to_not eq nil
      end

      it 'post invalid question' do
        post api_path, params: {access_token: access_token.token, question: attributes_for(:question, :invalid)}.to_json, headers: headers
        expect(json.first).to eq "Body can't be blank"
      end
    end
  end
end
