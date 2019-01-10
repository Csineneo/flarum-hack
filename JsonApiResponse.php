<?php
namespace Flarum\Api;

use Tobscure\JsonApi\Document;
use Zend\Diactoros\Response\JsonResponse;

class JsonApiResponse extends JsonResponse {
  public function __construct(Document $document, $status = 200, array $headers = [], $encodingOptions = 15) {
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
        $cctext = opencc_convert($document->jsonSerialize(), $ccconfig);
        opencc_close($ccconfig);
        break;
      case "zh-hk":
        $ccconfig = opencc_open("s2hk.json");
        $cctext = opencc_convert($document->jsonSerialize(), $ccconfig);
        opencc_close($ccconfig);
        break;
      case "zh-tw":
      case "zh":
        $ccconfig = opencc_open("s2tw.json");
        $cctext = opencc_convert($document->jsonSerialize(), $ccconfig);
        opencc_close($ccconfig);
        break;
      default:
        $cctext = $document->jsonSerialize();
    }
    parent::__construct($cctext, $status, $headers, $encodingOptions);
  }
}
