class LandmarksController < ApplicationController
    set :views, Proc.new { File.join(root, "../views/landmarks") }

  get '/landmarks' do
    @landmarks = Landmark.all
    erb :index
  end

  get '/landmarks/new' do 
    erb :new
  end

  post '/landmarks' do 
     @landmark = Landmark.create(params[:landmark])
      if !params[:figure][:name].empty?
        @landmark.figure = Figure.create(name: params[:figure][:name])
      end
     @landmark.save
     redirect to "/landmarks", locals: {message: "Successfully created Landmark."}
  end

  get '/landmarks/:id' do 
    @landmark = Landmark.find_by_id(params[:id])
    erb :show
  end

  get '/landmarks/:id/edit' do
    @landmark = Landmark.find_by_id(params[:id])
    erb :edit
  end

  patch '/landmarks/:id' do 
    @landmark = Landmark.find_by_id(params[:id])
    if params[:landmark][:name] != @landmark.name
      @landmark.name = params[:landmark][:name]
    end
    
    if params[:landmark][:year_completed] != @landmark.year_completed
      @landmark.year_completed = params[:landmark][:year_completed]
    end


    @landmark.save
    redirect to "/landmarks/#{@landmark.id}", locals: {message: "Sucessfully edited Landmark."}
  end
end
