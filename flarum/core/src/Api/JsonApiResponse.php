<?php

/*
 * This file is part of Flarum.
 *
 * For detailed copyright and license information, please view the
 * LICENSE file that was distributed with this source code.
 */

namespace Flarum\Api;

use Laminas\Diactoros\Response\JsonResponse;
use Tobscure\JsonApi\Document;

class JsonApiResponse extends JsonResponse
{
    /**
     * {@inheritdoc}
     */
    public function __construct(Document $document, $status = 200, array $headers = [], $encodingOptions = 15)
    {
        $headers['content-type'] = 'application/vnd.api+json';

				$lang="";
				if(isset($_SERVER["HTTP_ACCEPT_LANGUAGE"])) {
					preg_match('/^([a-z\-]+)/i', $_SERVER['HTTP_ACCEPT_LANGUAGE'], $matches);
					$lang = strtolower($matches[1]);
				}

				switch ($lang) {
					case "zh-cn":
					case "zh-sg":
						$ccconfig = opencc_open("t2s.json");
						break;
					case "zh-hk":
						$ccconfig = opencc_open("s2hk.json");
						break;
					case "zh-tw":
					case "zh":
						$ccconfig = opencc_open("s2tw.json");
						break;
					default:
						$ccconfig = "";
				}

				if ( $ccconfig ) {
					$cctext = opencc_convert(json_encode($document->jsonSerialize(), 256), $ccconfig);
					opencc_close($ccconfig);
					parent::__construct(json_decode($cctext), $status, $headers, $encodingOptions);
				} else {
					// The call to jsonSerialize prevents rare issues with json_encode() failing with a
					// syntax error even though Document implements the JsonSerializable interface.
					// See https://github.com/flarum/core/issues/685
					parent::__construct($document->jsonSerialize(), $status, $headers, $encodingOptions);
				}
    }
}
