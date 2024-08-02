class BaseService
  protected

  def save_and_return(record, &block)
    if record.valid?
      if record.save
        block&.call if block_given?
      end

      record.reload
      record
    else
      record.errors
    end
  end

  def add_attachment!(item, attachment)
    return false unless attachment
    item.attachment.attach(
      io: attachment,
      filename: 'attachment.jpg'
    )
  end
end
