# coding: utf-8

class RussianValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if !(value.blank? || (value =~ /\A[а-яё -]*\Z/iu))
      record.errors.add(attribute, (options[:message] || :wrong_language))
    end
  end
end
