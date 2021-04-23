class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :files
  has_many :answers
  has_many :comments
  has_many :links
  belongs_to :user

  def files
    h = []
    object.files.each do |file|
      h << { name: file.filename.to_s, url: Rails.application.routes.url_helpers.rails_blob_url(file, only_path: true ) }
    end
    h
  end
end
