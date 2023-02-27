ActiveAdmin.register Match do
  permit_params :title, :location, :number_of_players, :have_ball_and_shirtfronts, :start, :duration,
                :finish, :aasm_state, :withdrawal_perion

  index do
    selectable_column
    column :id
    column :title
    column :location
    column :number_of_players
    column :user_id
    column :have_ball_and_shirtfronts
    column :start
    column :duration
    column :finish
    column :aasm_state
    column 'Cancel Match' do |match|
      link_to 'Cancel', cancel_matches_path(id: match.id) if match.active?
    end
    actions
  end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :title, :location, :number_of_players, :user_id, :have_ball_and_shirtfronts, :start, :duration, :finish
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :location, :number_of_players, :user_id, :have_ball_and_shirtfronts, :start, :duration, :finish]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
