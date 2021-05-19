# frozen_string_literal: true

module DiscourseZendeskPlugin
  class IssueCommentsController < ApplicationController
    include ::DiscourseZendeskPlugin::Helper

    before_filter :load_topic, only: [:create, :update, :show]
    before_filter :load_post, only: [:update, :show]

    def update
      zendesk_comment_id = params[:zendesk_comment_id]
      @post.custom_fields[::DiscourseZendeskPlugin::ZENDESK_ID_FIELD] = zendesk_comment_id
      @post.save_custom_fields
      render json: success_json
    end

    def show
      render json: success_json
    end

    private

    def load_topic
      @topic = Topic.find(params[:topic_id])
      if @topic.custom_fields[::DiscourseZendeskPlugin::ZENDESK_ID_FIELD].blank?
        render json: failed_json.merge(error: 'No zendesk_id in topic'), status: 400
      end
    end

    def load_post
      @post = Post.find(params[:id].to_i)
      unless @post.topic_id == @topic.id
        render json: failed_json.merge(error: 'post topic_id mis-match'), status: 400
      end
    end
  end
end
