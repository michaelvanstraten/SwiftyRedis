//
//  {{ filename }}
//  
//
//  Created by Autogen on {{ creation_date }}.
//

import Foundation

public extension RedisConnection {
{% for command in commands %}
    {{ command.code() }}
{% endfor %}
}