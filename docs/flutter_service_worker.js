'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "1efa1dcfca200edf2b326f464de7902d",
"version.json": "1e80ec2937ab4d85c8636bed14233595",
"index.html": "89c0a57cf4a701d657c8e66d1a6e3088",
"/": "89c0a57cf4a701d657c8e66d1a6e3088",
"main.dart.js": "2779c1ea834037dfb147822ffd27d614",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "6a114127626acdc20f70cb5a32a15154",
"assets/NOTICES": "24bb9914c60e58b083544958aad4b620",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "2ac1cda9d0eb82d87fd3f879d3c17c35",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/kpostal/assets/kakao_postcode_localhost.html": "27eb159f48fb5b0af42e06afe3998688",
"assets/packages/flutter_inappwebview_web/assets/web/web_support.js": "509ae636cfdd93e49b5a6eaf0f06d79f",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.css": "5a8d0222407e388155d7d1395a75d5b9",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.html": "16911fcc170c8af1c5457940bd0bf055",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/AssetManifest.bin": "fb75c6e2afb0ce41e0a83a13385fcabd",
"assets/fonts/MaterialIcons-Regular.otf": "266e9a716ecb9391b56149b619ac030c",
"assets/assets/images/products/dog_food_organic.jpg": "64c9dfca6857372b3455c85266b64623",
"assets/assets/images/products/dog_snack_duck_bone.jpg": "2d6abc9b95a929cd72f5ad48e8503254",
"assets/assets/images/products/auto_feeder_wifi.jpg": "29d352f616114dc7553fd9d7d90ecf28",
"assets/assets/images/products/cat_snack_chaoture.jpg": "6e39128bbcdac3ad16ed35bbf4950e8b",
"assets/assets/images/products/cat_food_wellness.jpg": "1f5121d0729be38a15966fd8bb64160c",
"assets/assets/images/products/cat_tower_scratcher.jpg": "4368effd5ada2a076f9ca7203d4d280d",
"assets/assets/images/products/dog_vitamins_total.jpg": "2a7b9102b40a61f7234ee765ad7a6759",
"assets/assets/images/products/pet_dryroom.jpg": "cd37f8dc3273b1b28f8fa2ffe1c9e7d1",
"assets/assets/images/products/dog_toy_tennis_ball.jpg": "298c3caccf001e006ecdc091ddc6b4e9",
"assets/assets/images/products/cat_snack_tuna_can.jpg": "2139c9f2191e6978184f614371f9da92",
"assets/assets/images/pet_logo.png": "e779263337b084c2c29bc43dce3acad3",
"assets/assets/images/co-pet_logo.png": "994ee4d476a6f842341e1d8d36fcfdf4",
"assets/assets/images/banners/main_banner_coupon.jpg": "0ad45c93112e5e70cde0f8faa1c6e0f4",
"assets/assets/images/community/post_dog_grooming.jpg": "cfaf3c83a3c613a0fd2c50511beebe2e",
"assets/assets/images/community/post_cat_grooming.jpg": "ecce7436ced2d2d0e457f62287b28bf7",
"assets/assets/images/community/post_dog_basic.jpg": "070e83d854e573c8736585a677bbc752",
"assets/assets/images/community/post_dog_walk.jpg": "fd8cdbb03432658926afd85a597488d6",
"assets/assets/images/community/post_dog_cute.jpg": "d6443a376cc07422e70fc79058fa567c",
"assets/assets/images/community/post_cat_angry.jpg": "96873f18a8efa552357b28408dc4d986",
"assets/assets/images/community/post_cat_model.jpg": "7949d655dfe9259ecb9078a88d523536",
"assets/assets/images/community/post_dog_daily.jpg": "1d0e9e41e1439f37f6cd55c0ae6487cb",
"assets/assets/images/community/post_dog_supply.jpg": "0c20be100cb3602c97829ebcde72dc1d",
"assets/assets/images/community/post_dog_training.jpg": "e3aced616a50b82993491efc2f6d3cc9",
"assets/assets/images/co-pet_logo_t.png": "07e02aebb449fbeffccbac93f124f5e5",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
