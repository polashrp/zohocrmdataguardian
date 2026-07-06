addressFields = Map();
// ===== PART 1: Try Known Field Names First =====
streetOptions = List();
streetOptions.add("Street");
streetOptions.add("Mailing_Street");
streetOptions.add("Billing_Street");
streetOptions.add("Shipping_Street");
streetOptions.add("Address_1_Street_Address");
streetOptions.add("Address_2_Street_Address");
cityOptions = List();
cityOptions.add("City");
cityOptions.add("Mailing_City");
cityOptions.add("Billing_City");
cityOptions.add("Shipping_City");
cityOptions.add("Address_1_City");
cityOptions.add("Address_2_City");
stateOptions = List();
stateOptions.add("State");
stateOptions.add("Mailing_State");
stateOptions.add("Billing_State");
stateOptions.add("Shipping_State");
stateOptions.add("Address_1_State_Province");
stateOptions.add("Address_2_State_Province");
zipOptions = List();
zipOptions.add("Zip_Code");
zipOptions.add("Mailing_Zip");
zipOptions.add("Mailing_Code");
zipOptions.add("Billing_Zip");
zipOptions.add("Billing_Code");
zipOptions.add("Shipping_Zip");
zipOptions.add("Shipping_Code");
zipOptions.add("Address_1_Zip_Postal_Code");
zipOptions.add("Address_2_Zip_Postal_Code");
zipOptions.add("Zip");
zipOptions.add("Code");
countryOptions = List();
countryOptions.add("Country");
countryOptions.add("Mailing_Country");
countryOptions.add("Billing_Country");
countryOptions.add("Shipping_Country");
countryOptions.add("Address_1_Country_Region");
countryOptions.add("Address_2_Country_Region");
// Try known field names first
streetValue = "";
cityValue = "";
stateValue = "";
zipValue = "";
countryValue = "";
for each  option in streetOptions
{
	val = recordDetails.get(option);
	if(val != null && val != "")
	{
		streetValue = val.toString();
		break;
	}
}
for each  option in cityOptions
{
	val = recordDetails.get(option);
	if(val != null && val != "")
	{
		cityValue = val.toString();
		break;
	}
}
for each  option in stateOptions
{
	val = recordDetails.get(option);
	if(val != null && val != "")
	{
		stateValue = val.toString();
		break;
	}
}
for each  option in zipOptions
{
	val = recordDetails.get(option);
	if(val != null && val != "")
	{
		zipValue = val.toString();
		break;
	}
}
for each  option in countryOptions
{
	val = recordDetails.get(option);
	if(val != null && val != "")
	{
		countryValue = val.toString();
		break;
	}
}
// ===== PART 2: Dynamic Scan for Custom Fields =====
// Only scan if any address component is still empty
if(streetValue == "" || cityValue == "" || stateValue == "" || zipValue == "" || countryValue == "")
{
	// Keywords for dynamic detection
	streetKeywords = List();
	streetKeywords.add("street");
	streetKeywords.add("address");
	cityKeywords = List();
	cityKeywords.add("city");
	cityKeywords.add("town");
	stateKeywords = List();
	stateKeywords.add("state");
	stateKeywords.add("province");
	stateKeywords.add("region");
	zipKeywords = List();
	zipKeywords.add("zip");
	zipKeywords.add("code");
	zipKeywords.add("postal");
	countryKeywords = List();
	countryKeywords.add("country");
	countryKeywords.add("nation");
	// Get all keys from the record
	allKeys = recordDetails.keys();
	for each  key in allKeys
	{
		keyLower = key.toString().toLowerCase();
		value = recordDetails.get(key);
		// Skip null/empty values
		if(value == null || value == "")
		{
			continue;
		}
		// Skip system fields (start with $)
		if(keyLower.startsWith("$"))
		{
			continue;
		}
		// Skip known non-address fields
		if(keyLower.contains("email") || keyLower.contains("phone") || keyLower.contains("mobile") || keyLower.contains("name") || keyLower.contains("score") || keyLower.contains("status") || keyLower.contains("owner") || keyLower.contains("time") || keyLower.contains("source") || keyLower.contains("industry") || keyLower.contains("website") || keyLower.contains("revenue") || keyLower.contains("description") || keyLower.contains("rating") || keyLower.contains("fax") || keyLower.contains("twitter") || keyLower.contains("skype") || keyLower.contains("designation"))
		{
			continue;
		}
		// Only scan if this component is still empty
		if(streetValue == "")
		{
			for each  keyword in streetKeywords
			{
				if(keyLower.contains(keyword) && !keyLower.contains("city") && !keyLower.contains("state") && !keyLower.contains("country") && !keyLower.contains("zip") && !keyLower.contains("code"))
				{
					streetValue = value.toString();
					info "Dynamic: Found street from '" + key + "'";
					break;
				}
			}
		}
		if(cityValue == "")
		{
			for each  keyword in cityKeywords
			{
				if(keyLower.contains(keyword) && !keyLower.contains("state") && !keyLower.contains("country"))
				{
					cityValue = value.toString();
					info "Dynamic: Found city from '" + key + "'";
					break;
				}
			}
		}
		if(stateValue == "")
		{
			for each  keyword in stateKeywords
			{
				if(keyLower.contains(keyword) && !keyLower.contains("country"))
				{
					stateValue = value.toString();
					info "Dynamic: Found state from '" + key + "'";
					break;
				}
			}
		}
		if(zipValue == "")
		{
			for each  keyword in zipKeywords
			{
				if(keyLower.contains(keyword) && !keyLower.contains("country") && !keyLower.contains("state"))
				{
					zipValue = value.toString();
					info "Dynamic: Found zip from '" + key + "'";
					break;
				}
			}
		}
		if(countryValue == "")
		{
			for each  keyword in countryKeywords
			{
				if(keyLower.contains(keyword) && !keyLower.contains("state"))
				{
					countryValue = value.toString();
					info "Dynamic: Found country from '" + key + "'";
					break;
				}
			}
		}
		// If all found, exit loop early
		if(streetValue != "" && cityValue != "" && stateValue != "" && zipValue != "" && countryValue != "")
		{
			break;
		}
	}
}
// Store results
addressFields.put("street",streetValue);
addressFields.put("city",cityValue);
addressFields.put("state",stateValue);
addressFields.put("zip",zipValue);
addressFields.put("country",countryValue);
info "=== Detected Address ===";
info "Street: " + streetValue;
info "City: " + cityValue;
info "State: " + stateValue;
info "Zip: " + zipValue;
info "Country: " + countryValue;
return addressFields;
