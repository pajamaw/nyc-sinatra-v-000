class FiguresController < ApplicationController
    set :views, Proc.new { File.join(root, "../views/figures") }

  get '/figures' do
    @figures = Figure.all
    erb :index
  end

  get '/figures/new' do 
    erb :new
  end

  post '/figures' do
     #code to create a new song and save to DB
     @figure = Figure.create(params[:figure])
      if !params[:title][:name].empty?
        @figure.titles << Title.create(name: params[:title][:name])
      end
      if !params[:landmark][:name].empty?
        @figure.landmarks << Landmark.create(name: params[:landmark][:name])
      end
     @figure.save
     redirect to "/figures", locals: {message: "Successfully created Figure."}
  end

  get '/figures/:id' do 
    @figure = Figure.find_by_id(params[:id])
    erb :show
  end

  get '/figures/:id/edit' do 
    @figure = Figure.find_by_id(params[:id])
    erb :edit
  end

  patch '/figures/:id' do 
    @figure = Figure.find_by_id(params[:id])
    if params[:figure][:name] != @figure.name
      @figure.name = params[:figure][:name]
    end

    @figure.titles = []
      if params[:figure][:title_ids]
        params[:figure][:title_ids].each do |title|
          @figure.titles << Title.find(title)
      end
    end
    
    if !params[:title][:name].empty?
      @figure.titles << Title.find_or_create_by(name: params[:title][:name])
    end
    

    @figure.landmarks = [] 
      if params[:figure][:landmark_ids]

        params[:figure][:landmark_ids].each do |landmark|
          @figure.landmarks << Landmark.find(landmark)
      end
    end
    
    if !params[:landmark][:name].empty?
      @figure.landmarks << Landmark.find_or_create_by(name: params[:landmark][:name])
    end


    @figure.save
    redirect to "/figures/#{@figure.id}", locals: {message: "Sucessfully edited Figure."}
  end
end
