;; -*-scheme-*-
;; Airat Izmailov, 2020.  Public Domain.
;; so long as remove this block of comments from your script
;; feel free to use it for whatever you like.

(define (draw-guides image
					 image-width
					 device-width
					 column-count
					 gutter-width)
	(if (> device-width image-width)
		(set! device-width image-width)
	)
	(let* (
		(left-gutter (/ (- image-width device-width) 2))
		(column-width (/ device-width column-count))
		(n 0)
		)
		
		(set! gutter-width (/ gutter-width 2))
		(while (< n (+ column-count 1))
			(gimp-image-add-vguide image left-gutter)
			(if (> n 0)
				(if (>= (- left-gutter gutter-width) 0)
					(gimp-image-add-vguide image (- left-gutter gutter-width))
				)
			)
			(if (< n column-count)
				(if (<= (+ left-gutter gutter-width) image-width) 
					(gimp-image-add-vguide image (+ left-gutter gutter-width))
				)
			)
			(set! left-gutter (+ left-gutter column-width)) 
			(set! n (+ n 1)) 
		)
	)
)

(define (script-fu-guides-for-bootstrap image
										drawable
										device-size
										column-count
										gutter-width)
	(let* (
		(width (car (gimp-image-width image)))
		(height (car (gimp-image-height image)))
        )
		
		(if (= device-size 0)
			(draw-guides image width 500 column-count gutter-width)
			(if (= device-size 1)
				(draw-guides image width 540 column-count gutter-width)
				(if (= device-size 2)
					(draw-guides image width 720 column-count gutter-width)
					(if (= device-size 3)
						(draw-guides image width 960 column-count gutter-width)
						(if (= device-size 4)
							(draw-guides image width 1140 column-count gutter-width)
							(draw-guides image width 1320 column-count gutter-width)
						)
					)
				)
			)
		)

		(gimp-displays-flush)
	)
)

(script-fu-register "script-fu-guides-for-bootstrap"
  _"Create a guides for bootstrap grid"
  _"ctreate a guides at the vertical orientation and gutter width (in pixels)"
  "Airat Izmailov"
  "Airat Izmailov, 2020.  Public Domain."
  "2020-12-17"
  "*"
  SF-IMAGE      "Image"      0
  SF-DRAWABLE   "Drawable"   0
  SF-OPTION     _"_Device size" '(_"Extra small (<576px)" _"Small (≥576px)" _"Medium (≥768px)" _"Large (≥992px)" _"Extra large (≥1200px)" _"Extra extra large (≥1400px)")
  SF-ADJUSTMENT _"_Column count" (list 12 1 12 1 1 0 0)
  SF-ADJUSTMENT _"_Gutter width"  (list 30 0 1400 1 10 0 0)
)

(script-fu-menu-register "script-fu-guides-for-bootstrap"
                         "<Image>/Image/Guides")
