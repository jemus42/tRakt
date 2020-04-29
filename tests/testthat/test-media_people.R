test_that("media_people works", {
  movies_people("deadpool-2016") %>%
    expect_named(c("cast", "crew")) %>%
    purrr::walk(~ {
      expect_is(.x, "tbl_df")
    })

  shows_people("breaking-bad") %>%
    expect_named(c("cast", "crew")) %>%
    purrr::walk(~ {
      expect_is(.x, "tbl_df")
    })

  shows_people("breaking-bad", guest_stars = TRUE) %>%
    expect_named(c("cast", "guest_stars", "crew")) %>%
    purrr::walk(~ {
      expect_is(.x, "tbl_df")
    })

  seasons_people("breaking-bad", season = 1) %>%
    expect_named(c("cast", "crew")) %>%
    purrr::walk(~ {
      expect_is(.x, "tbl_df")
    })

  seasons_people("breaking-bad", season = 1, guest_stars = TRUE) %>%
    expect_named(c("cast", "guest_stars", "crew")) %>%
    purrr::walk(~ {
      expect_is(.x, "tbl_df")
    })

  episodes_people("breaking-bad", season = 1, episode = 1) %>%
    expect_named(c("cast", "crew")) %>%
    purrr::walk(~ {
      expect_is(.x, "tbl_df")
    })

  episodes_people("breaking-bad", season = 1, episode = 1, guest_stars = TRUE) %>%
    expect_named(c("cast", "guest_stars", "crew")) %>%
    purrr::walk(~ {
      expect_is(.x, "tbl_df")
    })

})
