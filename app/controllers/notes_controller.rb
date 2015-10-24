class NotesController < ApplicationController

  layout "notes"

  before_action :find_note, :only => [:show, :edit, :update, :delete, :destroy]
  before_action :confirm_logged_in
  before_action :find_user

  def index
    @notes = @user.notes.order("created_at DESC")
  end

  def show
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(note_params)
    @note.user = current_user
    if @note.save
    redirect_to(:action => "index", :id => @note.id)
    flash[:notice] = "Your note was successfully created. Click on the note to view."
    else
      render("new")
    end
  end

  def edit
  end

  def update
    if @note.update(note_params)
    redirect_to(:action => "show", :id => @note.id)
    flash[:notice] = "'#{@note.title}' updated successfully."
    else
      render("edit")
    end
  end
  
  def delete
    @user = Note.find(params[:id]).user
    if @user == current_user
      render("delete")
     else
     redirect_to(:controller => "notes", :action => "index")
     end
  end

  def destroy
    note = Note.find(params[:id])     
    note.destroy
    redirect_to(:action => "index")
    flash[:notice] = "your note '#{note.title}' was destroyed successfully."
  end

  private

  def find_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :content)
  end

def current_user
  current_user = User.find(session[:user_id])
end

def find_user
  @user = User.find(session[:user_id])
end

def confirm_logged_in
    unless session[:user_id]
      redirect_to(:controller => "users", :action => "index")
      return false
    else
      return true
    end
  end

end
