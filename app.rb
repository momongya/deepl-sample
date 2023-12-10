require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require 'net/http'
require 'uri'
require 'deepl'

configure do
  DeepL.configure do |config|
    config.auth_key = 'bd241b39-9494-977f-0b05-5e76eff01248:fx'
    config.host = 'https://api-free.deepl.com'
  end
end

get '/' do
  erb :index
end

post '/translate' do
  eng_title = params[:eng_title]

  begin
    source_lang, tr_text = deepl_translation(eng_title)
    "元の言語は #{source_lang} です。<br>翻訳: #{tr_text}"
  end
end

def deepl_translation(m_eng_title)
  english_title = m_eng_title

  # 不要なワードを削除
  text1 = english_title.gsub(/不要なワード/, '')
  raw_tr_text = text1

  # 翻訳実行
  translation = DeepL.translate(raw_tr_text, nil, 'JA')

  # 元の言語
  source_lang = translation.detected_source_language

  # 翻訳後のテキスト
  tr_text = translation.text

  return source_lang, tr_text
end
