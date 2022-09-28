class Admins::LeaseApplicationAttachments::DealershipMailsController < ApplicationController
  before_action :authenticate_admin_user!

  def create
    @file = LeaseApplicationAttachment.find(params[:id])
    MailToDealershipJob.perform_later(@file.id)
    flash[:notice] = 'The attachment will now be sent to the dealership'
    redirect_back(fallback_location: admins_root_path)
  end
end
