package com.rayaedu.rayaedu

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform