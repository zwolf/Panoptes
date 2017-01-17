module ActiveInteraction
  class OrganizationFilter < Filter
    register :organization

    def cast(value, context)
      schema = OrganizationUpdateSchema.schema[:properties]
      included_keys = value.keys.map {|z| z.to_sym}
      if included_keys.all? {|s| schema.key? s } && valid?(value)
        value
      else
        raise InvalidValueError, "#{name}: #{describe(value)}"
      end
    end

    def valid?(value)
      JSON::Validator.validate(OrganizationUpdateSchema.schema, value)
    end
  end
end