class ImageHelper
  require 'mini_magick'
  require 'securerandom'

  BASE_IMAGE_PATH = './app/assets/images/bg_image.png'.freeze
  GRAVITY = 'center'.freeze
  TEXT_POSITION = '0,0'.freeze
  FONT = './app/assets/fonts/komorebi-gothic.ttf'.freeze
  FONT_SIZE = 65
  INDENTION_COUNT = 11
  ROW_LIMIT = 8

  class << self
    # 合成後のFileClassを生成
    def build(text)
      text = prepare_text(text)
      @image = MiniMagick::Image.open(BASE_IMAGE_PATH)
      configuration(text)
    end

    # 合成後のFileの書き出し
    def write(text)
      build(text)
      @image.write uniq_file_name
    end

    private

    # uniqなファイル名を返却
    def uniq_file_name
      "#{SecureRandom.hex}.png"
    end

    # 設定関連の値を代入
    def configuration(text)
      @image.combine_options do |config|
        config.font FONT
        config.gravity GRAVITY
        config.pointsize FONT_SIZE
        config.draw "text #{TEXT_POSITION} '#{text}'"
      end
    end

    # 背景にいい感じに収まるように文字を調整して返却
    def prepare_text(text)
      text.scan(/.{1,#{INDENTION_COUNT}}/)[0...ROW_LIMIT].join("\n")
    end
  end
end