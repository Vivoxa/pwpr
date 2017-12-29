# frozen_string_literal: true

module InputOutput
  class ServerFileHandler
    SERVER_TMP_FILE_DIR = 'tmp'

    def self.server_file_path_for(file_name)
      "#{SERVER_TMP_FILE_DIR}/#{file_name}"
    end

    def self.delete_file_from_server(file_path)
      file = server_file_path_for(file_path)
      FileUtils.rm [file], force: true
    end
  end
end
