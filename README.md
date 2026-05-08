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

**Talk card includes time so VoiceOver gives complete information on focus** (`ParallelTalkCardView`, `ParallelSessionsRowView`)\
The session time was previously rendered in a separate left-hand column outside each talk card, so VoiceOver users had to focus the time element and the card element separately to understand a row. The time has been moved to the top-left of each card, the time column has been removed, and the card's accessibility label now reads "Talk from 09:30 to 10:15: [title], by [speakers], [location]" — giving the full context in a single focus stop.

**Talk card layout scales with Dynamic Type** (`ParallelTalkCardView`, `TimeColumnView`)\
The time column inside each talk card uses `@ScaledMetric` so its minimum width grows with the user's chosen text size, preventing the start and end times from truncating at AX text sizes. The reserved space at the bottom of each card (kept clear so the favourite star is not on top of the location text) also scales with Dynamic Type so the icon stays out of the way at every size.

### Mobility

**Favourite button has an enlarged touch target** (`FavouriteButtonView`)\
The star icon button was smaller than Apple's recommended 44×44-point minimum tap area. A minimum frame of 88×88 points has been applied — double the HIG minimum — so users with reduced dexterity, tremor, or limited fine motor control can comfortably and reliably activate it. The talk card reserves matching space below its text so the larger button does not obscure the title or speaker.

**Accessibility announcement on favourite toggle** (`FavouriteButtonView`)\
When a talk is added to favourites, VoiceOver announces "Added to favourites. Switch to My Schedule to see all your saved sessions." When removed, it announces "Removed from favourites." This gives VoiceOver users immediate confirmation of the action and directs them to the My Schedule tab, which already shows all saved sessions in order — achieving the same goal as in-list navigation without relying on complex rotor mechanics.

**Voice Control input label on the favourite button** (`FavouriteButtonView`)\
Voice Control users can activate the favourite button by saying "Tap Favourite", "Tap Star", or "Tap Save" rather than having to recite the full accessibility label. When several talk cards are visible Voice Control will number them automatically.

**Voice Control input label on talk cards** (`ParallelTalkCardView`)\
The card's full accessibility label is over seventy characters long (session type + time + title + speakers + location). `.accessibilityInputLabels` has been set to just the talk title so a Voice Control user can say "Tap [Talk Title]" instead.

### Cognitive

**Section headings announce as headers** (`SpeakerDetailView`, `MyScheduleView`)\
The "Sessions" heading on speaker detail pages and the day headings on My Schedule now carry the `.isHeader` accessibility trait. VoiceOver users can navigate by headings using the rotor, letting them jump straight to key sections without reading every element on screen.

**Social links hint that they open externally** (`SocialLinksView`)\
Each social or website link on a speaker's profile now has the hint "Opens in browser". This sets the user's expectation before they activate the link, avoiding confusion when they are taken out of the app.

**Favourite button announces selected state and explains its action** (`FavouriteButtonView`)\
When a talk is currently a favourite, the button carries the `.isSelected` accessibility trait so VoiceOver appends "Selected" to its announcement, giving users a quick read on the talk's saved status without having to interpret the icon. The button also has a hint ("Adds this session to your saved schedule" / "Removes this session from your saved schedule") so users understand the consequence of activating it before they double-tap.

**Voice Control input labels for composite rows** (`SpeakerRowView`, `TalkSummaryView`)\
After grouping rows into single combined elements, Voice Control users activate them by speaking a label. `.accessibilityInputLabels` has been set to the speaker name and talk title respectively, so users can say the shortest, most natural command (e.g. "tap Jane Smith") rather than having to speak a long combined description.

### Hearing (bonus)

**Differentiated haptic feedback when toggling a favourite** (`FavouriteButtonView`)\
A `.success` haptic fires when a talk is added to favourites, and a lighter `.impact(weight: .light)` haptic fires when a talk is removed. Two distinct tactile patterns let a user without sight or sound tell whether the action added or removed the talk, rather than just confirming that something happened. This is a non-auditory equivalent to a paired sound cue.

---

## Bug fixes

**Favourite button independently focusable by VoiceOver** (`ParallelTalkCardView`)\
The favourite star button was originally nested inside the talk card's `NavigationLink` label and hidden from VoiceOver, with the toggle exposed only as a custom accessibility action. Custom actions require the VoiceOver Actions rotor — a non-obvious gesture that most users will not discover. The button has been moved into an overlay on the card so it sits alongside the `NavigationLink` as a sibling element. Both can now be focused and double-tapped independently: the card navigates to the session detail, the button toggles the favourite.

**Favourite button independently focusable by VoiceOver — overlay approach** (`ParallelTalkCardView`)\
After moving the favourite button to an overlay sibling of the `NavigationLink`, the programme schedule has been restored to `LazyVStack` for performance. The button is reliably focusable and activatable by VoiceOver as a separate element from the card.

**Reliable VoiceOver announcements on favourite toggle** (`FavouriteButtonView`, `AccessibilityAnnouncer`)\
`UIAccessibility.post(notification: .announcement, ...)` is best-effort: iOS frequently drops announcements that are posted while VoiceOver is still speaking the button's own activation feedback, and a naive post also competes with VoiceOver auto-reading the updated button label. The fix has two parts. First, an `AccessibilityAnnouncer` helper posts each announcement as an `NSAttributedString` with `.accessibilitySpeechQueueAnnouncement` (so it queues behind in-flight speech rather than being dropped), waits a short delay so VoiceOver's activation tick can finish, and observes `UIAccessibility.announcementDidFinishNotification` to retry if the system reports the announcement was unsuccessful. Second, a `labelOverride` state variable on the button freezes the displayed accessibility label at its pre-tap state for four seconds so VoiceOver does not auto-read the new label mid-announcement. Once the freeze lifts, VoiceOver naturally re-reads the button with its updated label if focus remains on it.
