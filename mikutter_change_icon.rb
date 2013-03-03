#-*- coding: utf-8 -*-
require 'base64'

Plugin.create :change_icon do

  def self.update_profile_image(filename, system = true)
    begin
      img = open(filename)
      data = Base64.encode64(img.read)
      img.close
      deferred = (Service.primary.twitter/'account/update_profile_image').message({:image => data})
      if system
        Plugin.call(:update, nil, [Message.new(:message => "アイコン変更リクエストを送信しました（#{filename}）", :system => true)])
      end
    rescue Exception => e
      if system
        Plugin.call(:update, nil, [Message.new(:message => "アイコン変更中にエラーが発生しました．\n#{e.backtrace}", :system => true)])
      end
    end
  end

end

