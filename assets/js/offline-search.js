// Adapted from code by Matt Walters https://www.mattwalters.net/posts/hugo-and-lunr/

(function ($) {
    'use strict';

    $(document).ready(function () {
        const $searchInput = $('.td-search-input');

        //
        // Options for popover
        //

        $searchInput.data('html', true);
        $searchInput.data('placement', 'bottom');
        $searchInput.data(
            'template',
            '<div class="popover offline-search-result" role="tooltip"><div class="arrow"></div><h3 class="popover-header"></h3><div class="popover-body"></div></div>'
        );

        //
        // Register handler
        //

        $searchInput.on('change', (event) => {
            render($(event.target));

            // Hide keyboard on mobile browser
            $searchInput.blur();
        });

        // Prevent reloading page by enter key on sidebar search.
        $searchInput.closest('form').on('submit', () => {
            return false;
        });

        //
        // Fuse.js: https://fusejs.io/demo.html
        //

        let idx = null; // Fuse index
        const resultDetails = new Map(); // Will hold the data for the search results (titles and summaries)
        const options = {
            shouldSort: true,
            useExtendedSearch: true,
            includeMatches: true,
            findAllMatches: true,
            keys: [
                "title",
                "body",
                "excerpt",
            ]
        };

        // Set up for an Ajax call to request the JSON data file that is created by Hugo's build process
        $.ajax($searchInput.data('offline-search-index-json-src')).then(
            (data) => {
                data.forEach((doc) => {
                    resultDetails.set(doc.ref, {
                        title: doc.title,
                        excerpt: doc.excerpt,
                    });
                });

                idx = new Fuse(data, options);

                $searchInput.trigger('change');
            }
        );

        const render = ($targetSearchInput) => {
            // Dispose the previous result
            $targetSearchInput.popover('dispose');

            //
            // Search
            //

            if (idx === null) {
                return;
            }

            const searchQuery = $targetSearchInput.val();
            if (searchQuery === '') {
                return;
            }

            // hack: use extended include-match
            // ref: https://fusejs.io/examples.html#extended-search
            const includeSearch = `'${searchQuery}`;
            const results = idx.search(includeSearch);

            // filter results by language
            let getLang = function(refPath) {
                const langs = ['en', 'zh'];
                const segs = refPath.split('/');
                for (let i = 0; i < langs.length; i++) {
                    const lang = langs[i];
                    if (segs.includes(lang)) {
                        return lang;
                    }
                }
                return null;
            };

            const curLang = getLang(window.location.pathname);
            let resultsByLang = [];
            if (curLang) {
                results.forEach((item) => {
                    const ref = item.item.ref;
                    const itemLang = getLang(ref);
                    if (itemLang === curLang) {
                        resultsByLang.push(item);
                    }
                });
            } else {
                resultsByLang = results;
            }

            //
            // Make result html
            //
            const $html = $('<div>');

            $html.append(
                $('<div>')
                    .css({
                        display: 'flex',
                        justifyContent: 'space-between',
                        marginBottom: '1em',
                    })
                    .append(
                        $('<span>')
                            .text('Search results')
                            .css({ fontWeight: 'bold' })
                    )
                    .append(
                        $('<i>')
                            .addClass('fas fa-times search-result-close-button')
                            .css({
                                cursor: 'pointer',
                            })
                    )
            );

            const $searchResultBody = $('<div>').css({
                maxHeight: `calc(100vh - ${
                    $targetSearchInput.offset().top -
                    $(window).scrollTop() +
                    180
                }px)`,
                overflowY: 'auto',
            });
            $html.append($searchResultBody);

            if (resultsByLang.length === 0) {
                $searchResultBody.append(
                    $('<p>').text(`No results found for query "${searchQuery}"`)
                );
            } else {
                resultsByLang.forEach((or) => {
                    const r = or.item;
                    const doc = resultDetails.get(r.ref);
                    const href =
                        $searchInput.data('offline-search-base-href') +
                        r.ref.replace(/^\//, '');

                    const $entry = $('<div>').addClass('mt-4');

                    let ancherObj = $('<a>').addClass('d-block').css({
                        fontSize: '1.2rem',
                    }).attr('href', href).text(doc.title);
                    let descObj = $('<p>').text(doc.excerpt);
                    if (or.matches.length !== 0) {
                        for (let i = 0; i < or.matches.length; i++) {
                            const match = or.matches[i];
                            let value = match.value;
                            if (value.length > 512) {
                                value = value.substring(0, 512) + "...";
                            }
                            if (match.key === 'body') {
                                descObj = $('<p>').text(value);
                            }
                        }
                    }

                    $entry.append(ancherObj);
                    $entry.append(
                        $('<small>').addClass('d-block text-muted').text(r.ref)
                    );
                    $entry.append(descObj);

                    $searchResultBody.append($entry);
                });
            }

            $targetSearchInput.on('shown.bs.popover', () => {
                $('.search-result-close-button').on('click', () => {
                    $targetSearchInput.val('');
                    $targetSearchInput.trigger('change');
                });
            });

            $targetSearchInput
                .data('content', $html[0].outerHTML)
                .popover('show');
        };
    });
})(jQuery);
