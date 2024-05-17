# GraphQL Schema Description


## Shout Type

id
title
description
generic_type ( Type of GenericItem (will be 'Announcement') )
date_start (Date format acceptable "yyyy-mm-dd" )
date_end
time_start (Time format acceptable "hh:mm" )
time_end
announcement_types (List of categories)
media_content (include contentType / captionText / sourceUrl(url))
location (include city/street/ geoLocation(latitude / longitude))
max_number_of_quota (Max number of available redemptions/prticipants)
quota_frequency
quota_visibility ('public_visibility' / 'private_visibility')
participants (Array of participants ids)
organizer (Shout organizer, object with organizerType like "data_provider" and organizerId)
announcementable_type (Associated resource type like 'EventRecord' / 'NewsItem')
announcementable_id (Associated resource ID)
redemptions_count (Participants count)
redemptions_list (Participants info liek id / name)



## Create / Update Shout Input Type (GenericItem with generic_type 'announcement'), you can find examples in (create_shout.graphql / update_shout.graphql) files.

title
description
date_start (Date format acceptable "yyyy-mm-dd" )
date_end
time_start (Time format acceptable "hh:mm" )
time_end
organizer (This is an object(currently not used from create mutation, we set it from current_user data_provider), example of object { organizerType: "data_provider", organizerId: 5 } )
announcement_types: Array of strings like ['type1', 'type2']
participants: (Array of participants IDs, this is a members on backend side)

media_content ( Example structure of media content { contentType: "image (or video)", captionText: "some text", sourceUrl: { url: "http://example.com" } } )
location ( Example structure of location: { city: "city", street: "street", geoLocation: { longitude: 12.345, latitude: 12.345 } } )

max_number_of_quota (Max available redemptions/participants)
quota_frequency: -> Available frequencies: 'once' / 'daily' / 'weekly' / 'monthly' / 'quarterly' / 'yearly', 'once' is a default.

Attention, quota_visibility is not available to update through updateShout mutation.
quota_visibility: -> Available visibilities: ('public_visibility' or 'private_visibility'), when you set it to 'public_visibility' during create it can't be changed to private by API

announcementable_type (Type of the associated entity ('NewsItem', 'EventRecord'))
announcementable_id (ID of the associated entity)


## API-Endpoints

- createShoutMutation: Create new Shout(Announcement) -> Example query in create_shout.graphql file
- updateShoutMutation: Update existing Shout(Announcement) -> Example query in update_shout.graphql file
- RedeemQuotaOfAnnouncement: Add participant to Shout(Announcement)
- shouts: Query that return all upcomin shouts for current user
- destroyRecord: Destroy existing Shout (accept ID of a resource and recordType: 'GenericItem')