# frozen_string_literal: true

module Decidim
  module Forms
    # This module serializes the answers given by a User for questionnaire so can be
    # exported to CSV, JSON or other formats.
    module UserAnswersSerializerOverrides

      # Public: Exports a hash with the serialized data for the user answers.
      def serialize
        @answers.each_with_index.inject({}) do |serialized, (answer, idx)|
          serialized.update(
            answer_translated_attribute_name(:id) => answer.session_token,
            answer_translated_attribute_name(:created_at) => answer.created_at.to_s(:db),
            answer_translated_attribute_name(:ip_hash) => answer.ip_hash,
            answer_translated_attribute_name(:user_status) => answer_translated_attribute_name(answer.decidim_user_id.present? ? "registered" : "unregistered")
          )
          serialized.update(add_answers(answer, idx))
          serialized
        end
      end

      private

      def add_answers(answer, idx)
        serialized_answers = {}
        if answer.choices.present?
          serialized_answers.update(normalize_choices(idx, answer, answer.choices))
        else
          serialized_answers.update(
            "#{idx + 1}. #{translated_attribute(answer.question.body)}" => normalize_body(answer)
          )
        end
        serialized_answers
      end

      def normalize_body(answer)
        answer.body || normalize_attachments(answer)
      end

      def normalize_attachments(answer)
        return if answer.attachments.blank?

        answer.attachments.map(&:url)
      end

      def normalize_choices(idx, answer, choices)
        return { "#{idx + 1} #{translated_attribute(answer.question.body)}" => normalize_matrix_choices(answer, choices) } if answer.question.matrix?

        answer.question.answer_options.load_target.each_with_index.inject({}) do |serialized, (answer_option, idx1)|
          choice = choices.map.select { |x| x[:decidim_answer_option_id] == answer_option.id }
          unless choice.empty?
            if choice.first.custom_body.nil?
              body = choice.first.body if choice.first.respond_to?("body")
              serialized.update({ "#{idx + 1}.#{idx1 + 1} #{translated_attribute(answer.question.body)} / #{translated_attribute(answer_option.body)}" => body })
            else
              serialized.update({ "#{idx + 1}.#{idx1 + 1} #{translated_attribute(answer.question.body)} / #{choice.first.body}" => choice.first.custom_body })
            end
          end
          serialized
        end
      end

      def normalize_matrix_choices(answer, choices)
        answer.question.matrix_rows.map do |matrix_row|
          row_body = translated_attribute(matrix_row.body)

          row_choices = answer.question.answer_options.map do |answer_option|
            choice = choices.find_by(matrix_row: matrix_row, answer_option: answer_option)
            choice.try(:custom_body) || choice.try(:body)
          end

          [row_body, row_choices]
        end.to_h
      end

      def answer_translated_attribute_name(attribute)
        I18n.t(attribute.to_sym, scope: "decidim.forms.user_answers_serializer")
      end
    end
  end
end
