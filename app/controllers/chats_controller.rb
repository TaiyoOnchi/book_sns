class ChatsController < ApplicationController
  def show
    @followed_user=User.find(params[:user_id])
    @follower_user=User.find(current_user.id)
    @chat=Chat.new
    
    #@followed_userと@follower_userのidが一致するchat1を取得
    relationship1 = Relationship.find_by(followed_id: @followed_user.id, follower_id: @follower_user.id)
    chats1 = Chat.where(relationship_id: relationship1)

		#@followed_userと@follower_userのidを逆にしてchat2を取得
    relationship2 = Relationship.find_by(followed_id: @follower_user.id, follower_id: @followed_user.id)
    chats2 = Chat.where(relationship_id: relationship2)

		#chat1とchat2をマージし、投稿順にソート
    @chats = (chats1 + chats2).sort_by(&:created_at)
  end

  def create
    followed_user= User.find(params[:user_id])
    relationship = Relationship.find_by(followed_id: followed_user.id, follower_id: current_user.id)
    chat = current_user.chats.new(chat_params)
    chat.relationship_id = relationship.id
    chat.save
    redirect_to user_relationships_chat_path(followed_user.id,current_user.id)
  end

  def chat_params
    params.require(:chat).permit(:body)
  end
end
