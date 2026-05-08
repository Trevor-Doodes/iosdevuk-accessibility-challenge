# iOSDevUK Accessibility Challenge 2026

Welcome to the iOSDevUK Accessibility Challenge! 
Your mission, if you choose to accept, is to make the iOSDevUK conference app more accessible. (See MythConf/ in this repo for the code)
You'll have from May 7th until May 21st (GAAD) to work on the code and submit a pull request on this repo.

For more details, including judging criteria, you can check out [this link](https://www.iosdevuk.com/competition).

For all other questions, you can [email me at hello@robinkanatzar.com](mailto:hello@robinkanatzar.com)

Best of luck to you all!

---

## Accessibility Improvements

The following changes have been made to the MythConf app to improve its accessibility across Apple's Human Interface Guidelines categories.

### Vision

**Speaker photos now have text alternatives** (`SpeakerPhotoView`)\
Every speaker photo is labelled with the speaker's name (e.g. "Jane Smith's profile photo"). When no personal photo is available the fallback image is labelled "Profile photo not available". Previously the images were invisible to VoiceOver, giving users no indication of whose photo they were viewing.

**Map view now has an accessible description** (`LocationDetailView`)\
The interactive map on each location detail screen is labelled "Map showing the location of [Venue Name]" with a hint directing users to the text description below. Without this, VoiceOver users received no useful information from the map element.

**Break and social rows convey type without relying on colour alone** (`BreakRowView`)\
Rows such as Lunch, Tea Break, and Conference Dinner used a tinted background as the only visual distinction between session types. Each row now has a combined accessibility label that reads the session type and time range aloud (e.g. "Lunch, 12:30 to 14:00"), making the information available to users who cannot perceive colour.

**Increased Contrast and Reduce Transparency adaptation** (`ParallelTalkCardView`, `BreakRowView`)\
When the user has enabled Increase Contrast or Reduce Transparency in Settings, the tinted card and row backgrounds increase from 10–12% opacity to 25%, and talk cards gain a visible colour border. This ensures session-type colours remain distinguishable for users with low vision without relying on the default faint tinting.

**Decorative dividers hidden from VoiceOver** (`DayScheduleView`, `SpeakerDetailView`)\
Horizontal divider lines are decorative separators with no semantic meaning. They are now marked as hidden from the accessibility tree, removing unnecessary noise from VoiceOver navigation.

**Speaker rows and talk summary cards read as single elements** (`SpeakerRowView`, `TalkSummaryView`)\
A speaker row (photo + name + bio excerpt) and a talk summary card (title + time + location) each previously fragmented into multiple separate VoiceOver focus stops. Each composite element is now grouped so VoiceOver reads all the information in a single announcement, reducing the effort needed to scan a list.

**Nested favourite button hidden inside talk cards** (`ParallelTalkCardView`)\
The favourite star button inside each talk card created a second, redundant focusable element inside the card. The card already exposes an accessible custom action ("Add to favourites" / "Remove from favourites"), so the inner button is now hidden from VoiceOver to remove the duplication.

### Mobility

**Favourite button meets the 44×44-point minimum touch target** (`FavouriteButtonView`)\
The star icon button was smaller than Apple's recommended 44×44-point minimum tap area. A minimum frame has been applied so users with reduced dexterity can reliably activate it.

**Accessibility announcement on favourite toggle** (`FavouriteButtonView`)\
When a talk is added to favourites, VoiceOver announces "Added to favourites. Switch to My Schedule to see all your saved sessions." When removed, it announces "Removed from favourites." This gives VoiceOver users immediate confirmation of the action and directs them to the My Schedule tab, which already shows all saved sessions in order — achieving the same goal as in-list navigation without relying on complex rotor mechanics.

### Cognitive

**Section headings announce as headers** (`SpeakerDetailView`, `MyScheduleView`)\
The "Sessions" heading on speaker detail pages and the day headings on My Schedule now carry the `.isHeader` accessibility trait. VoiceOver users can navigate by headings using the rotor, letting them jump straight to key sections without reading every element on screen.

**Social links hint that they open externally** (`SocialLinksView`)\
Each social or website link on a speaker's profile now has the hint "Opens in browser". This sets the user's expectation before they activate the link, avoiding confusion when they are taken out of the app.

**Voice Control input labels for composite rows** (`SpeakerRowView`, `TalkSummaryView`)\
After grouping rows into single combined elements, Voice Control users activate them by speaking a label. `.accessibilityInputLabels` has been set to the speaker name and talk title respectively, so users can say the shortest, most natural command (e.g. "tap Jane Smith") rather than having to speak a long combined description.

### Hearing (bonus)

**Haptic feedback when toggling a favourite** (`FavouriteButtonView`)\
A success haptic fires each time a talk is added to or removed from favourites. This provides a tactile confirmation of the action for users who may not be relying on visual feedback alone, and is a non-auditory equivalent to a sound cue.

---

## Bug fixes

**Favourite button independently focusable by VoiceOver** (`ParallelTalkCardView`)\
The favourite star button was originally nested inside the talk card's `NavigationLink` label and hidden from VoiceOver, with the toggle exposed only as a custom accessibility action. Custom actions require the VoiceOver Actions rotor — a non-obvious gesture that most users will not discover. The button has been moved into an overlay on the card so it sits alongside the `NavigationLink` as a sibling element. Both can now be focused and double-tapped independently: the card navigates to the session detail, the button toggles the favourite.

**Favourite button independently focusable by VoiceOver — overlay approach** (`ParallelTalkCardView`)\
After moving the favourite button to an overlay sibling of the `NavigationLink`, the programme schedule has been restored to `LazyVStack` for performance. The button is reliably focusable and activatable by VoiceOver as a separate element from the card.
