require 'fileutils'

FactoryBot.define do
  factory(:upload) do
    rating { "s" }
    uploader factory: :user, level: 20, created_at: 2.weeks.ago
    uploader_ip_addr { "127.0.0.1" }
    tag_string { "special" }
    status { "pending" }
    source { "xxx" }
    file_size { 2.megabyte }
    md5 { "abc123" }
    image_width { 100 }
    image_height { 100 }

    factory(:source_upload) do
      source { "http://www.google.com/intl/en_ALL/images/logo.gif" }
      file_ext { "gif" }
    end

    factory(:jpg_upload) do
      file do
        f = Tempfile.new
        IO.copy_stream("#{Rails.root}/test/files/test.jpg", f.path)
        ActionDispatch::Http::UploadedFile.new(tempfile: f, filename: "test.jpg")
      end
      file_ext { "jpg" }
    end

    factory(:large_jpg_upload) do
      file do
        f = Tempfile.new
        IO.copy_stream("#{Rails.root}/test/files/test-large.jpg", f.path)
        ActionDispatch::Http::UploadedFile.new(tempfile: f, filename: "test.jpg")
      end
      file_ext { "png" }
    end
  end
end
