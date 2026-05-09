# Accessibility Audit Results

A structured record of the manual accessibility validation carried out for the iOSDevUK Accessibility Challenge 2026 submission. Code-side improvements are documented in the main [`README.md`](../README.md); this file captures the on-device verification.

**Device:** _e.g. iPhone 15 Pro running iOS 18.x_
**Tester:** Trevor Doodes
**Date completed:** _YYYY-MM-DD_

---

## Per-screen audit

For each screen, walk through with each assistive technology and tick when verified or note any issue with a brief description and the corresponding code change (if any).

### Programme tab

| Check | VoiceOver | Voice Control | Increase Contrast | Differentiate Without Color | AX5 Dynamic Type | Reduce Motion |
|---|---|---|---|---|---|---|
| Day picker reads correctly | ☐ | ☐ | ☐ | n/a | ☐ | ☐ |
| Talk cards read in one focus stop | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Time reads naturally ("from 09:30 to 10:15") | ☐ | n/a | ☐ | n/a | ☐ | n/a |
| Speakers and location follow the title | ☐ | n/a | n/a | n/a | n/a | n/a |
| Favourite button focusable separately from card | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| 88pt favourite hit area comfortable | n/a | n/a | n/a | n/a | ☐ | n/a |
| Favourite announces "Selected" when active | ☐ | n/a | n/a | n/a | n/a | n/a |
| Custom announcement plays cleanly | ☐ | n/a | n/a | n/a | n/a | n/a |
| Differentiated haptic — add vs remove distinguishable | n/a | n/a | n/a | n/a | n/a | n/a |
| Break rows show session-type symbol | n/a | n/a | n/a | ☐ | ☐ | n/a |
| Card border visible | n/a | n/a | ☐ | ☐ | n/a | n/a |
| Time column doesn't truncate | n/a | n/a | n/a | n/a | ☐ | n/a |
| Star bounce respects Reduce Motion | n/a | n/a | n/a | n/a | n/a | ☐ |

**Notes:** _add findings here_

### Speakers tab

| Check | VoiceOver | Voice Control | Increase Contrast | AX5 Dynamic Type |
|---|---|---|---|---|
| Speaker rows read as one focus stop | ☐ | ☐ | ☐ | ☐ |
| Voice Control activates by speaker name | n/a | ☐ | n/a | n/a |
| Search field announces result count | ☐ | n/a | n/a | n/a |
| Bio text adapts to Increase Contrast | n/a | n/a | ☐ | n/a |
| Speaker detail "Sessions" announces as heading | ☐ | n/a | n/a | n/a |
| Social links hint "Opens in browser" | ☐ | n/a | n/a | n/a |

**Notes:**

### Locations tab

| Check | VoiceOver | Voice Control | Increase Contrast | AX5 Dynamic Type |
|---|---|---|---|---|
| Location rows read as one focus stop | ☐ | ☐ | ☐ | ☐ |
| Voice Control activates by location name | n/a | ☐ | n/a | n/a |
| Map labelled with venue name | ☐ | n/a | n/a | n/a |
| Map hint directs to text description | ☐ | n/a | n/a | n/a |
| Description text adapts to Increase Contrast | n/a | n/a | ☐ | n/a |

**Notes:**

### My Schedule tab

| Check | VoiceOver | Voice Control | Increase Contrast | AX5 Dynamic Type |
|---|---|---|---|---|
| Empty state reads sensibly | ☐ | n/a | n/a | n/a |
| Day headings announced as headers | ☐ | n/a | n/a | n/a |
| Sessions read as on the Programme tab | ☐ | ☐ | ☐ | ☐ |
| No double-announce when scrolling pinned headers | ☐ | n/a | n/a | n/a |

**Notes:**

### Session detail

| Check | VoiceOver | Voice Control | Increase Contrast | AX5 Dynamic Type |
|---|---|---|---|---|
| Title announced as heading | ☐ | n/a | n/a | ☐ |
| Time and location read clearly | ☐ | n/a | ☐ | ☐ |
| Speakers focusable as composite rows | ☐ | ☐ | ☐ | ☐ |
| Description reads as one block | ☐ | n/a | n/a | ☐ |
| Toolbar favourite button compact, not oversized | n/a | n/a | n/a | ☐ |
| Toolbar favourite announces selected state | ☐ | n/a | n/a | n/a |
| Toolbar favourite triggers same announcement | ☐ | n/a | n/a | n/a |

**Notes:**

### Tab bar

| Check | VoiceOver | Voice Control |
|---|---|---|
| Each tab has an item label | ☐ | n/a |
| Voice Control accepts each natural alias | n/a | ☐ |

**Notes:**

---

## Accessibility Inspector audit

Run **Xcode → Open Developer Tool → Accessibility Inspector → Audit** on each screen with the iOS Simulator running. Capture warnings and resolutions below.

| Screen | Warnings found | Resolved? | Notes |
|---|---|---|---|
| Programme | _0_ | ✅ / ❌ | |
| Programme — talk card | | | |
| Programme — break row | | | |
| Speakers list | | | |
| Speaker detail | | | |
| Locations list | | | |
| Location detail | | | |
| Session detail | | | |
| My Schedule (empty) | | | |
| My Schedule (with favourites) | | | |

---

## Dynamic Type stress test (AX5)

| Screen | Layout intact at AX5? | Notes |
|---|---|---|
| Programme | ☐ | |
| Speakers | ☐ | |
| Locations | ☐ | |
| My Schedule | ☐ | |
| Session detail | ☐ | |
| Speaker detail | ☐ | |
| Location detail | ☐ | |

---

## Differentiated haptic verification (real device only)

| Action | Haptic perceived | Distinguishable from the other action? |
|---|---|---|
| Add to favourites (`.success`) | ☐ | ☐ |
| Remove from favourites (`.impact(weight: .light)`) | ☐ | ☐ |

---

## Outcomes

_Summarise the overall result of the validation pass: anything that was working as designed, anything caught and fixed, anything intentionally accepted as a known limitation._
