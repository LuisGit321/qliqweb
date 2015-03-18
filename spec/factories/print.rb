FactoryGirl.define do
  factory :print do
    image_file_name     "My Amazing Printing"
    image_file_size     "564Kb"
    image_content_type  "JPEG"
    user
  end
end
