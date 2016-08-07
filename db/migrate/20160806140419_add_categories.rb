class AddCategories < ActiveRecord::Migration[5.0]
  def change
    categories = [
        {
            name: 'Information technology',
            children: [
                {
                    name: 'Development',
                    children: [
                        { name: 'Ruby on Rails' },
                        { name: 'PHP' },
                        { name: 'JavaScript' }
                    ]
                },
                { name: 'Databases' },
                { name: 'Quality assurance' },
                { name: 'IT management' },
            ]
        },
        { name: 'Marketing' },
        { name: 'Insurance' }
    ]
    (create_categories = lambda { |children, parent|
      children.each do |child|
        category = Category.create(name: child[:name], parent: parent)
        create_categories.call(child[:children], category) if child[:children]
      end
    }).call(categories, nil)
  end
end
