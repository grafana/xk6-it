/**
 * **k6 extension for xk6 integration testing**
 *
 * @module it
 */
export as namespace it;

/**
 * ascii85encode returns the ASCII86 encoding of src.
 *
 * @param src The input to encode.
 */
export declare function ascii85encode(src: ArrayBuffer): string;
/**
 * ascii85decode returns the decoded bytes represented by the string str.
 *
 * @param str The string to decode.
 */
export declare function ascii85decode(str: string): ArrayBuffer;

/**
 * base32encode returns the base32 encoding of src.
 *
 * @param src The input to encode.
 */
export declare function base32encode(src: ArrayBuffer): string;
/**
 * base32decode returns the decoded bytes represented by the string str.
 *
 * @param str The string to decode.
 */
export declare function base32decode(str: string): ArrayBuffer;

/**
 * base64encode returns the base64 encoding of src.
 *
 * @param src The input to encode.
 */
export declare function base64encode(src: ArrayBuffer): string;
/**
 * base64decode returns the decoded bytes represented by the string str.
 *
 * @param str The string to decode.
 */
export declare function base64decode(str: string): ArrayBuffer;

/**
 * crc32checksum returns the CRC32 checksum of src.
 *
 * @param src The input to checksum.
 */
export declare function crc32checksum(src: ArrayBuffer): string;

/**
 * sha256sum returns the SHA-256 hash of src.
 *
 * @param src The input to hash.
 */
export declare function sha256sum(src: ArrayBuffer): string;

/**
 * sha512sum returns the SHA-512 hash of src.
 *
 * @param src The input to hash.
 */
export declare function sha512sum(src: ArrayBuffer): string;

/**
 * equal reports whether x and y are "deeply equal".
 *
 * @param x value to compare
 * @param y value to compare
 */
export declare function equal(x: any, y: any): boolean;
