# frozen_string_literal: true

module DiscourseZendeskPlugin
  class Engine < ::Rails::Engine
    engine_name 'discourse-zendesk-plugin'
    isolate_namespace DiscourseZendeskPlugin

    config.after_initialize do
      Discourse::Application.routes.append do
        get '/zendesk-plugin/topics/:topic_id/issue_comments/:id' => 'discourse_zendesk_plugin/issue_comments/#show', constraints: StaffConstraint.new
        post '/zendesk-plugin/topics/:topic_id/issue_comments/:id' => 'discourse_zendesk_plugin/issue_comments#update', constraints: StaffConstraint.new
        post '/zendesk-plugin/issues' => 'discourse_zendesk_plugin/issues#create', constraints: StaffConstraint.new
        put '/zendesk-plugin/sync' => 'discourse_zendesk_plugin/sync#webhook'
      end
    end
  end
end
