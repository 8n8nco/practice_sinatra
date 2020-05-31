# frozen_string_literal: true

require "sinatra/base"
require "sinatra/reloader"
require "cgi"
require_relative "file.rb"

module MemoApp
  class Memo < Sinatra::Base
    enable :method_override

    helpers do
      def esc_html(str)
        CGI.escapeHTML(str).split(/\R/).join("<br>")
      end
    end

    get "/" do
      @title = "トップ"
      @filenames = Dir.glob("*", base: "files")
      erb :index
    end

    get "/new/?" do
      @title = "作成"
      erb :new
    end

    post "/create" do
      MemoApp::File.new.write(params[:content])
      redirect "/"
    end

    get "/:id/?" do
      not_found unless ::File.exist?("files/#{params[:id]}")
      @title = "メモの内容"
      @filename = params[:id]
      @content = MemoApp::File.new(params[:id]).read
      erb :show
    end

    get "/edit/:id/?" do
      not_found unless ::File.exist?("files/#{params[:id]}")
      @title = "編集"
      @filename = params[:id]
      @content = MemoApp::File.new(params[:id]).read
      erb :edit
    end

    patch "/:id" do
      not_found unless ::File.exist?("files/#{params[:id]}")
      MemoApp::File.new(params[:id]).write(params[:content])
      redirect "/#{params[:id]}"
    end

    delete "/:id" do
      not_found unless ::File.exist?("files/#{params[:id]}")
      MemoApp::File.new(params[:id]).delete
      redirect "/"
    end

    not_found do
      @title = "ページが見つかりませんでした"
      erb :"404"
    end

    run! if app_file == $0
  end
end
