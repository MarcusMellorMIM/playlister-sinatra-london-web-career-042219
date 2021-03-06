class SongsController < ApplicationController

    get "/songs" do
        @songs=Song.all 
        erb :"/songs/index"
    end

    get "/songs/new" do 
        @genres=Genre.all
        erb :"/songs/new"
    end

    get "/songs/:slug" do
        @message=params[:message]
        @song=Song.find_by_slug( params[:slug])
        erb :"/songs/show"
    end

    post "/songs" do
        song=Song.create(params[:song])
        artist=Artist.where("name like ?", ( params[:artist][:name] )).first
        if !artist 
            artist=Artist.create(params[:artist])
        end
        Song.update( song.id, artist_id:artist.id )
        redirect "/songs/#{song.slug}?message=Successfully created song."
    end

    get "/songs/:slug/edit" do
        @song=Song.find_by_slug( params[:slug])
        @genres=Genre.all
        erb :"/songs/edit"
    end

    patch "/songs/:slug" do
        artist =Artist.find_or_create_by(name: params[:artist][:name])
        params[:song][:artist_id]=artist.id
        song=Song.find_by_slug( params[:slug] )
        song.update( params[:song] )
        redirect "/songs/#{song.slug}?message=Successfully updated song."
    end
end