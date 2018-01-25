FactoryBot.define do
  factory :subject_set do
    sequence(:display_name) { |n| "Subject Set #{n}" }

    metadata({ just_some: "stuff" })
    project

    after(:create) do |ss|
      if ss.workflows.empty?
        create_list(:workflow, 1, subject_sets: [ss])
      end
    end

    factory :subject_set_with_subjects do
      after(:create) do |set|
        2.times do |i|
          subject = create(:subject, project: set.project, uploader: set.project.owner)
          create(:set_member_subject, subject_set: set, subject: subject)
        end
        set.set_member_subjects_count = set.set_member_subjects.count
      end
    end
  end
end
