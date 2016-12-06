
class QueueItemsController < ApplicationController
  before_filter :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    add_queue_item(video)
    redirect_to my_queue_path
  end

  def destroy
    QueueItem.destroy(params[:id]) if in_user_queue?(params[:id])
    current_user.normalize_queue_positions
    redirect_to my_queue_path
  end

  def update_queue
    update_queue_items
    current_user.normalize_queue_positions
    redirect_to my_queue_path
  end

  private

  def add_queue_item(video) 
    current_user.queue_items.create(video: video, position: next_item_position ) unless video.already_in_queue?(current_user)
  end

  def next_item_position
    current_user.queue_items.count + 1
  end

  def in_user_queue?(item_id) 
    QueueItem.find(item_id).user == current_user
  end

  def update_queue_items 
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |h|
        item = QueueItem.find(h[:id])
        if in_user_queue?(item.id) 
          item.update(position: h[:position])
          item.rating = h[:rating]
        end
      end
    end
  end
end