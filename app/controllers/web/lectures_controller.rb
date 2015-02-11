# -*- coding: utf-8 -*-
class Web::LecturesController < Web::ApplicationController
  def index
    @lectures_with_lector = LectureDecorator.decorate_collection Lecture.includes(:workshop, :user).web.with_active_speaker.by_listener_votes.ransack(params[:q]).result
    @lectures_without_lector = LectureDecorator.decorate_collection Lecture.includes(:workshop).web.without_speaker.by_listener_votes.ransack(params[:q]).result
    @lectures = @lectures_with_lector + @lectures_without_lector
    @current_user_votings = LectureVoting.where(user_id: current_user.id) if current_user
    # вынести в show, если возможно, не забыть про хак в application.rb
    @lecture_id = params[:lecture_id]
    @lecture_by_id = LectureDecorator.decorate Lecture.find @lecture_id if @lecture_id
    #
    @workshops = Workshop.web
    respond_to do |format|
       format.html
       format.js
    end
  end
end
